#!/bin/bash

DEVICE="/dev/sdb"
MOUNT_POINT="/data"

{
    # Check if the device exists
    if [ ! -b "$DEVICE" ]; then
        echo "Device $DEVICE does not exist. Exiting."
        exit 1
    fi

    # Format the device with XFS filesystem
    echo "Formatting $DEVICE with XFS filesystem..."
    mkfs.xfs -f $DEVICE

    # Create the mount point directory if it doesn't exist
    if [ ! -d "$MOUNT_POINT" ]; then
        echo "Creating mount point $MOUNT_POINT..."
        mkdir -p $MOUNT_POINT
    fi

    # Mount the device to the mount point
    echo "Mounting $DEVICE to $MOUNT_POINT..."
    mount $DEVICE $MOUNT_POINT

    # Retrieve UUID of the device
    UUID=$(blkid -s UUID -o value $DEVICE)

    # Add entry to /etc/fstab for persistence
    echo "Updating /etc/fstab for persistent mounting..."
    echo "UUID=$UUID $MOUNT_POINT xfs defaults 0 0" >> /etc/fstab

    # Unmount and remount all filesystems in /etc/fstab to ensure changes are effective
    echo "Remounting all filesystems..."
    umount $MOUNT_POINT
    mount -a

    # Test writing a file to the mount point
    echo "Creating and writing to a test file in $MOUNT_POINT..."
    sudo touch $MOUNT_POINT/testfile.txt
    echo "hello" | sudo tee $MOUNT_POINT/testfile.txt > /dev/null

    # Verify the content of the test file
    echo "Verifying content of the test file..."
    cat $MOUNT_POINT/testfile.txt
} >> /var/log/ec2-user-data.log 2>&1