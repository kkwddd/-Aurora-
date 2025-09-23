#!/system/bin/sh

MODDIR=${0%/*}
CRON_DIR=$MODDIR/cron

# 等待系统启动完成
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

# 设置执行权限
chmod 755 "$MODDIR/bin/cleaner" >/dev/null 2>&1
chmod 755 "$MODDIR/bin/empty_cleaner" >/dev/null 2>&1


chmod 644 "$CRON_DIR/root"


if [ -f "/data/adb/ap/bin/busybox" ]; then
    CROND_CMD="/data/adb/ap/bin/busybox crond"
elif [ -f "/data/adb/ksu/bin/busybox" ]; then
    CROND_CMD="/data/adb/ksu/bin/busybox crond"
else
    MAGISK_PATH=$(magisk --path 2>/dev/null)
    if [ -n "$MAGISK_PATH" ] && [ -f "$MAGISK_PATH/.magisk/busybox/crond" ]; then
        CROND_CMD="$MAGISK_PATH/.magisk/busybox/crond"
    else
       
        CROND_CMD="$MODDIR/system/bin/busybox crond"
    fi
fi


pkill -f "crond" >/dev/null 2>&1
sleep 1

# 启动crond
if [ -n "$CROND_CMD" ]; then
    $CROND_CMD -c "$CRON_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - crond启动完成" >> "$MODDIR/cron.log"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 未找到可用的crond" >> "$MODDIR/cron.log"
fi
