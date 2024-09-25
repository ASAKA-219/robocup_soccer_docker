# robocup soccer simulation in docker
お知らせ
9/25：公式アーカイブから2023年のとあるチームのログデータを持ってきてます。
## これは何？
Dockerコンテナでロボカップサッカーのシミュレーターを立ち上げることができるパッケージです。
```bash
./entry_exec.sh
```
で実行し、コンテナに入ります。
```bash
nano ~/.bashrc
```
をして、環境変数に
```
PATH="/usr/local/bin:$PATH"
LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
```
がそこに登録されているか確認しましょう。すると
```bash
rcsoccersim
```
と打つと恐らくサッカー場のシミュレーターが起動するはずです。

## play a log data
2023年のファイナルのとあるチームのログデータを再生してみましょう。
まずコンテナに入ってサッカーシミュレーターを起動します。

```bash
コンテナを立てるために以下のコマンドを実行
./entry_exec.sh

コンテナ内で以下のコマンドを実行
rcsoccersim
```

起動したらターミナルをもう一個増やして
```bash
ls
```
で `202307090739-Hermes2D_2-vs-R3CESBU_6.rcg` がホームディレクトリにあるか確認しましょう。
あればサッカーシミュレーターで写真のように操作してください。
![demo](https://github.com/ASAKA-219/robocup_soccer_docker/blob/master/gif/Peek%202024-09-25%2023-41.gif)
