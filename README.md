# narou-mod-docker

このリポジトリは、[narou-mod](https://github.com/ponponusa/narou-mod) を Docker で動かすための構成です。
フォーク版では NAS 前提の PowerShell オーケストレーションをやめて、`docker compose` を前提にしています。

## 動作要件

- Docker Engine / Docker Desktop
- `docker compose` が使える環境

## 含まれるもの

- `narou-mod`
- 改造版 AozoraEpub3
- kindlegen 2.9

`narou-mod` と AozoraEpub3 はビルド時に GitHub Releases から取得します。
kindlegen はまず固定 URL から取得し、失敗した場合のみローカルの fallback アーカイブを使います。

## 使い方

### 1. 設定ファイルを作る

`.env.sample` を `.env` にコピーします。

```powershell
Copy-Item .env.sample .env
```

### 2. 必要なら `.env` を編集する

```env
HOST_NOVEL_PATH=./novel
HOST_PORT_RANGE=33000-33001
NAROU_MOD_VERSION=2.0.3-646d9ad
AOZORAEPUB3_VERSION=latest
```

- `HOST_NOVEL_PATH`: 小説データの保存先
- `HOST_PORT_RANGE`: 2つ連続したポート範囲。先頭が Web UI、次が websocket 用
- `NAROU_MOD_VERSION`: `latest` または GitHub Releases のタグ
- `AOZORAEPUB3_VERSION`: `latest` または GitHub Releases のタグ

Windows で絶対パスを使うなら、`C:/narou/novel` のように `/` 区切りを推奨します。

### 3. ビルドして起動する

```powershell
docker compose up --build -d
```

起動後は `http://localhost:33000` にアクセスしてください。
別のポート範囲を指定した場合は、先頭ポートにアクセスします。

### kindlegen のローカル fallback

kindlegen は `archive.org` から入手します。

`archive.org` からの取得に失敗した場合は、build context 内の次のファイルを使います。

```text
build/assets/kindlegen_linux_2.6_i386_v2_9.tar.gz
```

このファイルは Git 管理対象から外しています。ローカルで fallback を使いたい場合は、この場所に手元で配置してください。

## 停止と削除

```powershell
docker compose down
```

## 更新

バージョンを変えたら、再ビルド付きで起動し直してください。

```powershell
docker compose up --build -d
```

## データ保存先

既定では `./novel` をホスト側の保存先として使います。
このフォルダは `.gitignore` と `.dockerignore` に入れてあります。

## License

- 本ソフトウェアを利用（入手、インストール、実行等）した時点で、[利用規約・免責事項](https://github.com/ponponusa/narou-mod-docker/blob/main/TERMS_AND_DISCLAIMER.md)に同意したものとみなします。ご利用の前に必ず内容をご確認ください。
- This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
