# robocup soccer simulation in docker
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
