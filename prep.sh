#!/bin/bash

set -e
set -u
set -x

RELEASE=${RELEASE:-}
OMERO_BUILD=${OMERO_BUILD:-}
OMERO_ICE34_BUILD=${OMERO_ICE34_BUILD:-${OMERO_BUILD}}
BIOFORMATS_BUILD=${BIOFORMATS_BUILD:-}
OMERO_JOB=${OMERO_JOB:-OMERO-stable}
OMERO_ICE34_JOB=${OMERO_ICE34_JOB:-OMERO-stable-ice34}
BIOFORMATS_JOB=${BIOFORMATS_JOB:-BIOFORMATS-stable}
VIRTUALBOX_PATH=${VIRTUALBOX_PATH:-/ome/data_repo/virtualbox}
ARTIFACT_PATH=${ARTIFACT_PATH:-/ome/data_repo/releases}
SNAPSHOT_PATH=${SNAPSHOT_PATH:-/var/www/cvs.openmicroscopy.org.uk/snapshots}

# Test artifact directory existence
OMERO_ARTIFACT_PATH=$ARTIFACT_PATH/$OMERO_JOB/$OMERO_BUILD
[[ -d $OMERO_ARTIFACT_PATH ]] || exit
OMERO_ICE34_ARTIFACT_PATH=$ARTIFACT_PATH/$OMERO_ICE34_JOB/$OMERO_ICE34_BUILD
[[ -d $OMERO_ICE34_ARTIFACT_PATH ]] || exit
BIOFORMATS_ARTIFACT_PATH=$ARTIFACT_PATH/$BIOFORMATS_JOB/$BIOFORMATS_BUILD
[[ -d $BIOFORMATS_ARTIFACT_PATH ]] || exit

# Create OMERO & Bio-Formats directories
OMERO_SNAPSHOT_PATH=$SNAPSHOT_PATH/omero
[[ -d $OMERO_SNAPSHOT_PATH ]] ||  mkdir $OMERO_SNAPSHOT_PATH
BIOFORMATS_SNAPSHOT_PATH=$SNAPSHOT_PATH/bioformats
[[ -d $BIOFORMATS_SNAPSHOT_PATH ]] ||  mkdir $BIOFORMATS_SNAPSHOT_PATH
OMERO_VIRTUALBOX_PATH=$OMERO_SNAPSHOT_PATH/virtualbox
[[ -d $OMERO_VIRTUALBOX_PATH ]] ||  mkdir $OMERO_VIRTUALBOX_PATH

# Create OMERO release directory
OMERO_RELEASE_PATH=$OMERO_SNAPSHOT_PATH/$RELEASE
if [[ -d $OMERO_RELEASE_PATH ]]
then
    echo "$OMERO_RELEASE_PATH already exists"
    exit
else
    mkdir $OMERO_RELEASE_PATH
fi

# Create Bio-Formats release directory
BIOFORMATS_RELEASE_PATH=$BIOFORMATS_SNAPSHOT_PATH/$RELEASE
if [[ -d $BIOFORMATS_RELEASE_PATH ]]
then
    echo "$BIOFORMATS_RELEASE_PATH already exists"
    exit
else
    mkdir $BIOFORMATS_RELEASE_PATH
fi

# Symlink artifacts into release directories
for x in $OMERO_ARTIFACT_PATH/*;
    do ln -sf "$x" "$OMERO_RELEASE_PATH/";
done
for x in $OMERO_ICE34_ARTIFACT_PATH/*;
    do ln -sf "$x" "$OMERO_RELEASE_PATH/";
done
for x in $BIOFORMATS_ARTIFACT_PATH/*;
    do ln -sf "$x" "$BIOFORMATS_RELEASE_PATH/";
done

# Rename the OMERO virtualbox artifacts
cp $VIRTUALBOX_PATH/omero-vm-latest-build.ova "$OMERO_VIRTUALBOX_PATH/omero-vm-$RELEASE.ova"
cp $VIRTUALBOX_PATH/omero-vm-latest-build.ova.md5sum "$OMERO_VIRTUALBOX_PATH/omero-vm-$RELEASE.ova.md5sum"
perl -i -pe "s/latest-build/$RELEASE/" "$OMERO_VIRTUALBOX_PATH/omero-vm-$RELEASE.ova.md5sum"