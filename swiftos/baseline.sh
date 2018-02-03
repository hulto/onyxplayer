mkdir -p "$1/baselines"


service --status-all &>"$1/baselines/services"
lsof -i &>"$1/baselines/networkconn"
find / -type f \( -perm -04000 -o -perm -02000 \) &>"$1/baselines/suidbins"

find / -path /sys -prune -o -path /proc -prune -o -type f -mmin -5 &>"$1/baselines/lastfive"

