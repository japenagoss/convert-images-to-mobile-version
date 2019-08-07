#!/bin/bash
file=$1
image_id=$2

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

            if [ ! -d "/photomanager/tablets" ]
            then
                cd /photomanager
                mkdir tablets
            fi
            
            if [ ! -d "/photomanager/smartphones/$user" ]
            then
                cd /photomanager/smartphones
                mkdir $user
            fi

            if [ ! -d "/photomanager/tablets/$user" ]
            then
                cd /photomanager/tablets
                mkdir $user
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year" ]
            then
                cd /photomanager/smartphones/$user/
                mkdir $year
            fi

            if [ ! -d "/photomanager/tablets/$user/$year" ]
            then
                cd /photomanager/tablets/$user/
                mkdir $year
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month" ]
            then
                cd /photomanager/smartphones/$user/$year
                mkdir $month
            fi

            if [ ! -d "/photomanager/tablets/$user/$year/$month" ]
            then
                cd /photomanager/tablets/$user/$year
                mkdir $month
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month/$day" ]
            then
                cd /photomanager/smartphones/$user/$year/$month
                mkdir $day
            fi

            if [ ! -d "/photomanager/tablets/$user/$year/$month/$day" ]
            then
                cd /photomanager/tablets/$user/$year/$month
                mkdir $day
            fi

            if [ ! -d "/photomanager/smartphones/$user/$year/$month/$day/$hour" ]
            then
                cd /photomanager/smartphones/$user/$year/$month/$day
                mkdir $hour
            fi

            if [ ! -d "/photomanager/tablets/$user/$year/$month/$day/$hour" ]
            then
                cd /photomanager/tablets/$user/$year/$month/$day
                mkdir $hour
            fi

            if [ -d "/photomanager/smartphones/$user/$year/$month/$day/$hour" ]
            then
                # copy image to new dir
                cp $file /photomanager/smartphones/$user/$year/$month/$day/$hour/$name
            fi

            if [ -d "/photomanager/tablets/$user/$year/$month/$day/$hour" ]
            then
                # copy image to new dir
                cp $file /photomanager/tablets/$user/$year/$month/$day/$hour/$name
            fi

            if [ -f "/photomanager/smartphones/$user/$year/$month/$day/$hour/$name" ]
            then
                # Optimize image
                cd /photomanager/smartphones/$user/$year/$month/$day/$hour/
                sudo convert $name -quality 70 -resize 768 -strip -set comment "photomanager" $name
                
                 # Know if the file was optimized
                comment=$(identify -verbose $name | grep 'comment: photomanager')
                comment=$(echo "$comment" | cut -d ":" -f2)
                comment=$(echo "${comment/ /}")

                if [ "$comment" == "photomanager" ]; then
                    cd  /var/www/html/photomanager
                    artisan=$(php artisan smartphoneImage:save $image_id "/photomanager/smartphones/$user/$year/$month/$day/$hour/$name" 2>&1)
                fi
            fi

            if [ -f "/photomanager/tablets/$user/$year/$month/$day/$hour/$name" ]
            then
                # Optimize image
                cd /photomanager/tablets/$user/$year/$month/$day/$hour/
                sudo convert $name -quality 70 -resize 1200 -strip -set comment "photomanager" $name
                
                 # Know if the file was optimized
                comment=$(identify -verbose $name | grep 'comment: photomanager')
                comment=$(echo "$comment" | cut -d ":" -f2)
                comment=$(echo "${comment/ /}")

                if [ "$comment" == "photomanager" ]; then
                    cd  /var/www/html/photomanager
                    artisan=$(php artisan tabletImage:save $image_id "/photomanager/tablets/$user/$year/$month/$day/$hour/$name" 2>&1)
                fi
            fi
        fi
fi