
# Assumptions

The basic assumption is that all repos owned/managed by the Platform team
will be versioned/branched together such that when we package a version of
RM, all of the latest Platform zenpacks will be on the same
branch as the `manifest.json`file (e.g. `develop` for the latest release under
development or `support/5.0.x` for a 5.0.x maintenance release)

By contrast, when `manifest.json` is used to add Solution Zenpacks to an RM
image, we want to use the latest GA versions.  For the latest release of
RM under development, we can always get the latest GA copy of a Solution Zenpack
from the master branch. For a maintenance relaese of RM, we always want to use a
specific tagged version.

The following table defines the different values in `manifest.json` based on
ownership and release.

Repo Owner  | `repo` value on develop | `repo` value on support/* |
----------- | ----------------------- | ------------------------- |
Platform    | develop | support/* |
Solutions   | master  | value from VERSION in setup.py |

# Updating `manifest.json` for a maintenance release
There are four basic steps to update `manifest.json` for a maintenance release.

1. Sync your local
1. Verify the set of components
1. Get a list of latest zenpack versions
1. Update the versions in `manifest.json` as necessary

## Sync your local

The first step is make sure you have the latest source. `zendev restore develop` will sync your local enviroment with the latest development release across all of the various repositories involved.

You should also make sure you have the latest version of the `manifest.json` file the maintenance branch (support/5.0.x in this example):

```
$ cd europa/.manifest
$ git checkout support/5.0.x
$ git pull support/5.0.x
```

## Verify the set of components
In most cases, the set of components listed in manifest.json do not change from one maintenance release to another.
However, it is good idea to double-check the differences between develop and support branches to
make sure they are appropriate. For instance, something added to the evelop branch might be
necessary for a maintenance release. The `listRepos.sh` script in this directory can help identify differences.

The following commands will produce lists of repos managed by the Platform and Solution teams respectively.
Once the lists are generated, you can diff them to review the differences to see if any suggest a
component needs to be added or removed from the manifest

```
$ git checkout develop
$ ./listRepos.sh --platform >platform.develop
$ git checkout support/5.0.x
$ ./listRepos.sh --platform >platform.support
$ diff platform.develop platform.support

$ git checkout develop
$ ./listRepos.sh --solution >solution.develop
$ git checkout support/5.0.x
$ ./listRepos.sh --solution >solution.support
$ diff solution.develop solution.support
```

## Verify ZenPack versions
The `check-zenpack-versions` script will analyze all ZenPacks defined by the
manifest and print out which ZenPacks fall into the following categories. This
information is primarily meant to be used prior to a maintenance or feature
release to make sure that all ZenPacks are pointing to a tag. In most cases it
should be the latest tag.

- no ref (extremely unlikely, this is just broken)
- no local checkout (very possible if zendev isn't syncing the repository)
- no valid refs (some git issue preventing a list of refs from being obtained)
- pointing to a feature branch
- pointing to a hotfix branch
- pointing to the develop branch
- pointing to the master branch
- pointing to an tag that isn't the latest
- count of ZenPacks with refs pointing to the latest tag

## Update the versions in `manifest.json` as necessary

For each of the Solution zenpacks defined in `manifest.json` on the support branch (e.g. each zenpack in `solution.support`), compare the version defined in `manifest.json` to the latest GA version (e.g the version listed in `zenpack.Versions`).
Make any corrections as necessary.
