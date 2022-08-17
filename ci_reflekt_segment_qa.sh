#!/bin/sh
echo "$(date +"%T") Running Reflekt <-> Segment Protocols CI Suite"
echo "$(date +"%T")"
echo "$(date +"%T") Searching tracking plans"
plans=$(ls -- tracking-plans)

# Get a list of tracking plans
if [ -z "${plans}" ]; then
    echo "No tracking plans found in 'tracking-plans/'!"
    exit 1  # Exit if no tracking plans found
fi

echo "$(date +"%T") Found tracking plans:"

for plan in ${plans}; do
    echo "$(date +"%T")     ${plan}"
done;

# Loop the tracking plans
for plan in ${plans}; do
    echo "$(date +"%T")"
    echo "$(date +"%T") Checking tracking plan '${plan}' for changes..."

    # Build out --update args for reflekt push
    update_str=""
    update_events=$(git diff origin --name-only --diff-filter=AMR -- tracking-plans/${plan}/events)
    update_traits=$(git diff origin --name-only --diff-filter=AMR -- tracking-plans/${plan}/user-traits.yml tracking-plans/${plan}/group-traits.yml)
    updates=("${update_events[@]}" "${update_traits[@]}")

    echo "$(date +"%T") Checking for new/updated events or traits..."

    for update_file in ${updates}; do
        update_name=$(basename ${update_file} .yml)
        update_str="$update_str-u ${update_name} "
    done;

    # Run reflekt push with --update args
    if [ "${update_str}" != "" ]; then
        echo "$(date +"%T") Additions/updates detected. Running Reflekt command:\n$(date +"%T")     reflekt push -n ${plan} ${update_str} -t ${plan}-qa"
        reflekt push -n ${plan} ${update_str} -t ${plan}-qa
    else
        echo "$(date +"%T")     No new/updated events or traits detected"
    fi

    # Build out --remove args for reflekt push
    remove_str=""
    remove_events=$(git diff origin --name-only --diff-filter=D -- tracking-plans/${plan}/events)
    remove_traits=$(git diff origin --name-only --diff-filter=D -- tracking-plans/${plan}/user-traits.yml tracking-plans/${plan}/group-traits.yml)
    removals=("${remove_events[@]}" "${remove_traits[@]}")

    echo "$(date +"%T") Checking for removed events or traits..."

    for removal_file in ${removals}; do
        removal_name=$(basename ${removal_file} .yml)
        remove_str="$remove_str-r ${removal_name} "
    done;

    # Run reflekt push with --remove args
    if [ "${remove_str}" != "" ]; then
        echo "$(date +"%T") Removals detected. Running Reflekt command:\n$(date +"%T")     reflekt push -n ${plan} ${remove_str} -t ${plan}-qa"
        reflekt push -n ${plan} ${remove_str} -t ${plan}-qa
    else
        echo "$(date +"%T")     No removed events or traits detected"
    fi

done;
