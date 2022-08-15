# #!/bin/sh
plan_name=$1
events=$(ls /Users/gclunies/Repos/reflekt-demo/tracking-plans/my-segment-plan/events/*.yml)

for event_file in ${events}; do
    event=$(basename ${event_file} .yml)
    echo "running command: reflekt push -n ${plan_name} -u ${event} -t ${plan_name}-qa"
    reflekt push -n ${plan_name} -u ${event} -t ${plan_name}-qa
    echo
done;
