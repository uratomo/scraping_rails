#!/bin/bash
# コマンド実行が失敗したときに即座にシェルスクリプトを終了する
set -e

rm -f tmp/pids/server.pid

echo "========== bundle install =========="
bundle install

echo "========== Start WEBrick =========="
bundle exec rails server -p 3001 -b 0.0.0.0
