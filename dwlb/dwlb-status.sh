#!/bin/zsh
zmodload zsh/datetime

echo $$ > /tmp/dwlb.pid

prev_total=0
prev_idle=0

SLP_STEP=1

BAT_ICONS="󰂎󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"
HBLOCKS=" ▏▎▍▌▋▊▉█"

CAP_COL="666666"
BAT_LOW_COL="ff5555"
VOL_MUT_COL="ff5555"

CAP_L="^fg(${CAP_COL})▕^fg()"
CAP_R="^fg(${CAP_COL})▏^fg()"

# temp input file for cpu
TEMP_INPUT=""
for h in /sys/class/hwmon/hwmon*(N); do
	if [[ -f "$h/name" ]] && grep -q -E '^(coretemp|k10temp|zenpower)$' "$h/name"; then
		TEMP_INPUT="$h/temp1_input"
		break
	fi
done
if [[ -z "$TEMP_INPUT" || ! -f "$TEMP_INPUT" ]]; then
	for h in /sys/class/hwmon/hwmon*(N); do
		if [[ -f "$h/name" ]] && grep -q -E '^(thinkpad|cpu_thermal)$' "$h/name"; then
			TEMP_INPUT="$h/temp1_input"
			break
		fi
	done
fi

set_fg() {
    local col="$1"
    printf "^fg(%s)" "$col"
}

set_char_by_perc() {
	local perc=$1 chars=$2 len=${#2}
	(( perc < 0 )) && perc=0
	(( perc > 100 )) && perc=100
	local idx=$(( perc * len / 100 ))
	(( idx >= len )) && idx=$(( len - 1 ))
	_char="${chars:$idx:1}"
}

get_cpu_str() {
	local cpu_perc=0

	if read -r _ u n s idle iowait irq softirq steal _ < /proc/stat; then
		local total=$(( u + n + s + idle + iowait + irq + softirq + steal ))

		if (( prev_total > 0 && total > prev_total )); then
			local diff_total=$(( total - prev_total ))
			local diff_idle=$(( idle - prev_idle ))
			cpu_perc=$(( (diff_total - diff_idle) * 100 / diff_total ))
		fi

		prev_total=$total
		prev_idle=$idle
	fi

	local raw_temp
	read -r raw_temp < "$TEMP_INPUT" 2>/dev/null
	local temp_c=$(( ${raw_temp:-0} / 1000 ))

    CPU_STR="CPU ${cpu_perc}% ${temp_c}°"
}

get_ram_str() {
	local mem_total mem_avail k v

	while read -r k v _; do
		case $k in
			MemTotal:) mem_total=$v ;;
			MemAvailable:) mem_avail=$v; break ;;
		esac
	done < /proc/meminfo

    local mem_used_mb=$(( (mem_total - mem_avail + 512) >> 10 ))

    printf "RAM %dMiB" "$mem_used_mb"
}

get_bri_str() {
	local bri_raw=$(brightnessctl -m)
	local bri_field=${${(s:,:)bri_raw}[4]}
	local bri_perc=${bri_field%\%}

    printf "BRI %s%%" "$bri_perc"
}

get_vol_str() {
	local vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	if [[ "$vol_raw" == *"[MUTED]"* ]]; then
        printf "VOL %sMUT%s" "$(set_fg "$VOL_MUT_COL")" "$(set_fg "")"
	else
		local vol_num=${${=vol_raw}[2]}
		local vol_perc=$(( vol_num * 100 ))
		vol_perc=${vol_perc%.*}

        printf "VOL %s%%" "$vol_perc"
	fi
}

get_bt_str() {
	local bt_dev=$(wpctl status 2>/dev/null | awk '
	/Audio/ { in_audio=1 }
	/Video/ { in_audio=0 }
	in_audio && /Devices:/ { in_dev=1 }
	in_audio && /Sinks:/ { in_dev=0 }
	in_dev && /\[bluez5\]/ {
		sub(/^[ │├─└0-9.]+/, "")
		sub(/[ \t]*\[bluez5\].*$/, "")
		gsub(/^[ \t]+|[ \t]+$/, "")
		print $0
		exit
	}')

	if [[ -n "$bt_dev" ]]; then
		printf "󰂯 %s | " "$bt_dev"
	fi
}

get_power_str() {
	local bat_status bat_cap raw_power
	for f in /sys/class/power_supply/BAT*/status(N); do read -r bat_status < "$f"; break; done
	for f in /sys/class/power_supply/BAT*/capacity(N); do read -r bat_cap < "$f"; break; done

	if [[ "$bat_status" == "Discharging" ]] || (( ${bat_cap:-100} < 95 )); then
		for f in /sys/class/power_supply/BAT*/power_now(N); do read -r raw_power < "$f"; break; done
		local watts
		if [[ -n "$raw_power" ]]; then
			watts=$(printf "%4.1fW" $(( raw_power / 1000000.0 )))
		else
			watts=$(printf "%5s" "AC")
		fi
		set_char_by_perc ${bat_cap:-100} "$BAT_ICONS"
		[[ "$bat_status" == "Charging" ]] && _char="󰂄"
        if [[ $bat_cap -lt 20 ]]; then
            printf "%s%s %d%%%s %s | " "$(set_fg "$BAT_LOW_COL")" "$_char" "$bat_cap" "$(set_fg "")" "$watts"
        else
            printf "%s %s%% %s | " "$_char" "$bat_cap" "$watts"
        fi
	else
		POWER_STR=""
	fi
}

update_status() {
	get_cpu_str
	strftime -s CLOCK "%a %H:%M:%S" $EPOCHSECONDS
    printf "%s | %s | %s %s | %s%s%s\n" "$CPU_STR" "$(get_ram_str)" "$(get_bri_str)" "$(get_vol_str)" "$(get_bt_str)" "$(get_power_str)" "$CLOCK"
}

trap 'update_status' USR1
trap 'exec "$0"' HUP

while true; do
	update_status
	sleep $SLP_STEP &
	wait $!
done
