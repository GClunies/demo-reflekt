#!/bin/sh
echo "$(date +"%T") QA CI Suite: Reflekt <-> Segment Protocols"
echo "$(date +"%T")"
echo "$(date +"%T") Searching Reflekt project for tracking plans..."
echo "$(date +"%T")"
plans=$(ls -- tracking-plans | grep -v avo)  # Ignore my-avo-plan

# Get a list of tracking plans
if [ -z "${plans}" ]; then
    echo "$(date +"%T")     No tracking plans found in 'tracking-plans/'!"
    exit 1  # Exit if no tracking plans found
fi

echo "$(date +"%T") Found tracking plans:"

for plan in ${plans}; do
    echo "$(date +"%T")     ${plan}"
done;

# Loop the tracking plans
for plan in ${plans}; do
    echo "$(date +"%T")"
    echo "$(date +"%T") Searching tracking plan '${plan}' for changes..."

    # Build out --update args for reflekt push
    update_str=""
    update_events=$(git diff origin --name-only --diff-filter=AMR -- tracking-plans/${plan}/events)
    update_traits=$(git diff origin --name-only --diff-filter=AMR -- tracking-plans/${plan}/user-traits.yml tracking-plans/${plan}/group-traits.yml)
    updates=("${update_events[@]}" "${update_traits[@]}")

    echo "$(date +"%T") Searching for new/updated events or traits..."

    for update_file in ${updates}; do
        update_name=$(basename ${update_file} .yml)
        update_str="$update_str-u ${update_name} "
    done;

    # Run reflekt push with --update args
    if [ "${update_str}" != "" ]; then
        echo "$(date +"%T") Found new/updated events or traits. Running Reflekt command:\n$(date +"%T")\n$(date +"%T")     reflekt push -n ${plan} ${update_str}"
        echo "$(date +"%T")"
        reflekt push -n ${plan} ${update_str}
        echo "$(date +"%T")"
    else
        echo "$(date +"%T")     No new/updated events or traits found."
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
        echo "$(date +"%T") Found removed events or traits.Running Reflekt command:\n$(date +"%T")\n$(date +"%T")     reflekt push -n ${plan} ${remove_str}"
        echo "$(date +"%T")"
        reflekt push -n ${plan} ${remove_str}
        echo "$(date +"%T")"
    else
        echo "$(date +"%T")     No removed events or traits found."
    fi

done;
