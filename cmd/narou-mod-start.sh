#!/bin/sh

#
# コンテナ内で narou-mod を起動するスクリプト
#
# Copyright (c) 2025 ponponusa
#

set -eu

web_port=33000

echo "Starting narou-mod initialization..."
mkdir -p "$HOME/novel"
cd "$HOME/novel"
narou-mod version
narou-mod init --output-mode silent -p /opt/AozoraEpub3 -l 1.8

# server-ws-add-accepted-domains の現在の設定を取得
current_domains="$(narou-mod setting server-ws-add-accepted-domains)"
echo "Current accepted domains: $current_domains"

for domain in localhost 127.0.0.1; do
    case ",$current_domains," in
        *,"$domain",*)
            echo "$domain is already in accepted domains"
            ;;
        *)
            if [ -n "$current_domains" ]; then
                current_domains="${current_domains},${domain}"
            else
                current_domains="$domain"
            fi
            echo "Adding $domain to accepted domains"
            ;;
    esac
done

narou-mod setting server-ws-add-accepted-domains="$current_domains"

echo "Starting main web server on port $web_port..."
exec narou-mod web -np "$web_port"
