set -ex

export BGMI_LOG=debug
export BANGUMI_1=名侦探柯南
export BANGUMI_2=海贼王
export BANGUMI_3=黑色五叶草
coverage run -a -m unittest tests.test_controllers
coverage run -a -m unittest tests.test_config
cp tests/test_script.py $HOME/.bgmi/scripts/test_script.py
coverage run -a -m bgmi.main gen nginx.conf --server-name _
coverage run -a -m bgmi.main cal -f
coverage run -a -m bgmi.main config
coverage run -a -m bgmi.main config ADMIN_TOKEN 233
coverage run -a -m bgmi.main config DOWNLOAD_DELEGATE 'xunlei'
coverage run -a -m bgmi.main config BANGUMI_MOE_URL https://bangumi.moe
coverage run -a -m bgmi.main add $BANGUMI_1 $BANGUMI_2 $BANGUMI_3
coverage run -a -m bgmi.main update
coverage run -a -m bgmi.main delete --name $BANGUMI_3
coverage run -a -m bgmi.main delete --clear-all --batch
coverage run -a -m bgmi.main add $BANGUMI_2 --episode 1
coverage run -a -m bgmi.main fetch $BANGUMI_2
coverage run -a -m bgmi.main list
coverage run -a -m bgmi.main download --list
coverage run -a -m bgmi.main mark $BANGUMI_2 1
coverage run -a -m bgmi.main update $BANGUMI_2
coverage run -a -m bgmi.main filter $BANGUMI_2 --subtitle "" --exclude "MKV" --regex "720p|720P"
coverage run -a -m bgmi.main fetch $BANGUMI_2
coverage run -a -m unittest tests.test_http_api
coverage run -a -m bgmi.main search "海贼王" --regex-filter '.*MP4.*720P.*'
eval "$(coverage run -a -m bgmi.main complete)"

echo 'test mikan'
export BANGUMI_1=名侦探柯南
export BANGUMI_2=海贼王
coverage run -a -m bgmi.main source mikan_project
coverage run -a -m unittest tests.test_data_source

echo 'test dmhy'
export BANGUMI_1=名偵探柯南
export BANGUMI_2=海賊王
coverage run -a -m bgmi.main source dmhy
coverage run -a -m bgmi.main add $BANGUMI_2
coverage run -a -m bgmi.main fetch $BANGUMI_2
coverage run -a -m unittest tests.test_data_source

bash <(curl -s https://codecov.io/bash)
