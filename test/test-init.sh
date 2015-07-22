#!/bin/sh

. "test/testlib.sh"

begin_test "init again"
(
  set -e

  [ "git-lfs smudge %f" = "$(git config filter.lfs.smudge)" ]
  [ "git-lfs clean %f" = "$(git config filter.lfs.clean)" ]

  git lfs init

  [ "git-lfs smudge %f" = "$(git config filter.lfs.smudge)" ]
  [ "git-lfs clean %f" = "$(git config filter.lfs.clean)" ]
)
end_test

begin_test "init with old settings"
(
  set -e

  git config --global filter.lfs.smudge "git lfs smudge %f"
  git config --global filter.lfs.clean "git lfs clean %f"

  git lfs init 2> init.log

  grep "clean filter should be" init.log || {
    echo "no clean filter warning :("
    git config filter.lfs.smudge
    git config filter.lfs.clean
    exit 1
  }

  [ "git lfs smudge %f" = "$(git config filter.lfs.smudge)" ]
  [ "git lfs clean %f" = "$(git config filter.lfs.clean)" ]
)
end_test
