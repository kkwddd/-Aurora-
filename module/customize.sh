#!/sbin/sh
MODDIR=${0%/*}

chooseport() {
    local delay=${1:-3}   
    while true; do     
        timeout $delay /system/bin/getevent -lqc 1 2>&1 > $TMPDIR/events &
        sleep 0.5    
        if grep -q 'KEY_VOLUMEUP *DOWN' $TMPDIR/events; then
            return 0
        elif grep -q 'KEY_VOLUMEDOWN *DOWN' $TMPDIR/events; then
            return 1
        fi
    done
}

# 显示提示信息并获取选择
show_prompt() {
    echo "$1"
    echo "- ❄️上音量键: 是❄️"
    echo "- ❄️下音量键: 否❄️"
    chooseport
    return $?
}



ui_print "Aurora Cleaner 安装成功！定时任务已启用。"