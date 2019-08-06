#!/bin/bash
file=$1

# If the file exists it have to continue
if [ -f  $file ]
    then
        # Get user name
        user=$(echo "$file" | cut -d "/" -f4)

        # Get Name
        name=$(identify -verbose $file | grep "Image:")
        name=$(echo "$name" | cut -d " " -f2)
        name=$(echo $file | rev | cut -d "/" -f1 | rev)

        # Get Date
        date=$(echo "$name" | cut -d "." -f1)
        year=$(echo ${date:0:4})
        month=$(echo ${date:4:2})
        day=$(echo ${date:6:2})
        hour=$(echo ${date:8:2})
        minute=$(echo ${date:10:2})
        second=$(echo ${date:12:2})

        timestamp=$(date "+%s" -d "$month/$day/$year $hour:$minute:$second" 2>&1)

        re='^[0-9]+$'
        if [[ $timestamp =~ $re ]] ; then
            # Create dir to save the new file
            if [ ! -d "/photomanager/smartphones" ]
            then
                cd /photomanager
                mkdir smartphones
            fi
            
            if [ ! -d "/photomanager/smartphones/$user" ]
            then
                cd /photomanager/smartphones
                mkdir $user
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year" ]
            then
                cd /photomanager/smartphones/$user/
                mkdir $year
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month" ]
            then
                cd /photomanager/smartphones/$user/$year
                mkdir $month
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month/$day" ]
            then
                cd /photomanager/smartphones/$user/$year/$month
                mkdir $day
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month/$day/$hour" ]
            then
                cd /photomanager/smartphones/$user/$year/$month/$day
                mkdir $hour
            fi

            if [ -d "/photomanager/smartphones/$user/$year/$month/$day/$hour" ]
            then
                # copy image to new dir
                cp $file /photomanager/smartphones/$user/$year/$month/$day/$hour/$name
            fi
        fi
fi