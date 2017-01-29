# ChangeLog

### v1.2.0


1. 优化筛选和排序页面，现在可以通过手势从右侧滑出
2. 新增工具->活动信息查询，包含活动卡、歌曲、活动实时档位等信息
3. 新增“支持我们”页面，如果您喜欢这款应用，请支持我们
4. 新增技能发动间隔、技能触发几率、来源等卡片筛选条件
5. 新增人物3D模型、签名图、卡片图的查看功能
6. 修复一部分非限定SR卡被标记为限定卡的问题

##### Japanese version
1. フィルタとソートにおける機能向上、画面右側からのスワイプでスクリーニングメニューを呼び出せるようになりました。
2. 便利ツールにイベント情報一覧の機能を追加。イベントの限定カード、楽曲、リアルタイムランキングを見ることができます
3. 「開発者を応援する」ページを追加しました。このアプリを気に入った方は寄付する形で私たちに応援できるようになりました
4. カード検索のフィルターにて以下の条件を追加：スキル発動間隔、スキル発動確率、入手方法など
5. キャラクター3Dモデル、サイン画像、カード画像を見ている機能を追加しました
6. 一部の非限定Sレアカードが限定として表記されるバグを修正しました

##### English version
1. Improve sort and filter page, now it can be slid from the right side.
2. Add event information to tools tab, including event cards, song, ranking information.
3. Add "support us" page, if you like this application, please support us.
4. Add skill interval, skill proc rate, source as card filter methods.
5. Add 3D model, sign image, card image viewing page.
6. Fix the problem that some normal SR cards tagged as limited.

### v1.1.5
2016-12-11

1. 组队页面增加批量删除和复制功能
2. 完善模拟队伍算分和模拟抽卡的说明文字
3. 修复查看歌曲闪退的问题。如果某些谱面为空，请您尝试清除歌曲缓存后再重新下载。
4. 修复新付声角色在更新后仍然无法显示CV的问题

##### Japanese version
1. マイユニットのタブでバッチ削除・コピーができるになりました
2. スコア計算とガシャシミュの説明テキストを補足します
3. 譜面を確認した時アプリをクラッシュするバグを修正しました（互換性のため、一度楽曲のキャッシュをクリアしてください。）
4. CV実装したキャラが更新した後、CVが表示されないのバグが修正しました
5. 日本語翻訳の語彙を調整（[データを]アップデート→更新）

##### English version
1. Add mass copy and delete for team editing.
2. Add addition description for gacha simulation and team simulation.
3. Fix crash problem while entering beatmap page. If some beatmaps are still empty, please remove cache data and download again.
4. Fix the problem that characters with newly added cv cannot be updated to display the cv name.


### v1.1.4
2016-11-1

1. 优化谱面页面的FPS
2. 模拟抽卡中所有卡的概率改为和官方公布的概率一致
3. 角色可以按照生日和BMI排序

##### Japanese version
1. 譜面ページの流暢さ（FPS）を改善
2. ガシャシミュレーターで提供割合は公式の数値を採用
3. アイドル検索で二つのフィルタを追加：誕生日・BMI値

##### English version
1. Improve fps performance when scrolling beatmap.
2. Gacha simulation now have the same rate for each card as the formal data.
3. Character can be sorted by birthday and BMI.

### v1.1.3
2016-10-12

1. 增加清理缓存的二级页面，可以分类清除。近期部分谱面数据出错，请您尝试使用此功能手工清理再重新下载。
2. 优化谱面导出功能，统一不同设备导出谱面的规格
3. 修复iPad导出谱面崩溃的问题
4. 增加了一个耗时任务提示框

##### Japanese version
1. キャッシュクリアが分類ごとでクリアすることができました。（最近の譜面データは誤り点がありますので、一度クリアしてください）
2. 譜面画像の保存の機能向上
3. iPadで譜面画像の保存時クラッシュする問題を修正した
4. 一部のプロセスがポップアップボックスを付いています

##### English version
1. Add English localization(thanks to summertriangle-dev).
2. Add category for data wiping. You can use this feature to remove wrong data manually and download again.
3. Improve beatmap exporting feature, and export the same image on different devices.
4. Fix crash when exporting beatmap on iPad.
5. Add a "please wait" hud when processing task.

### v1.1.2
2016-10-4

1. 谱面页面新增镜像翻转的功能
2. 歌曲得分计算增加对live parade模式的支持
3. 歌曲筛选活动类型增加live parade模式
4. 修正系统语言设置为繁体中文-台湾时, 部分本地化字符串不生效的问题

##### Japanese version
1. 譜面ビューアーでミラージュ機能を追加した
2. LIVEスコアの計算にLIVE Paradeモードを追加した
3. 楽曲検索でLIVE Paradeのフィルタを追加した
4. 繁体字中国語で一部ローカライズされた文字列が反映されませんの問題を修正した

### v1.1.1
2016-10-1

1. 添加对繁体中文和日文支持(根据设备默认语言自动选择)
2. 修复三色队在Groove中去掉队友队长后不能触发自己队长的达成条件时，错误的仍然按照触发了队长技能计算表现值的问题 
3. 模拟抽卡页面增加卡池中各稀有度的几率

##### Japanese version
1. 中国語繁体字と日本語向けにローカライズした
2. fesアイドルがユニットセンターになる時、センター効果の発効条件が設置されたゲストアイドルをまとめ誤って判定して、Grooveのスコア計算を違った結果を出す問題を修正した
3. ガシャシミュレーターのUIで提供割合を表示します

### v1.1.0
2016-9-23

1. 工具->模拟抽卡正式上线
2. 队伍编辑页面新增对潜能解放的支持
3. 卡片详情页面添加卡片的获取途径
4. 生日提醒页面显示当前系统是否允许app通知
5. 当页面层级过多时，底部会出现一个返回主页的按钮
6. 大量界面细节优化

### v1.0.6
2016-9-14

1. 修复计算打歌平均分数时没有考虑偶像和歌曲(或groove颜色)同色时技能触发几率提高30%的因素(感谢吧友timeseal)
2. 改进计算技能触发几率和持续时间的算法(感谢吧友statementreply)
3. 修复iOS9.0之前的系统进入偶像生日提醒时崩溃的问题
4. 卡片页面添加按技能类型筛选
5. iPhone6之后的手机和所有的iPad上，卡片列表中也可以看到技能持续时间和触发几率
6. 修复双叶杏的星座描述文字
7. 生日提醒中的角色头像也可以跳转到角色信息页面

### v1.0.5
2016-9-8  

1. 工具->角色信息查询正式上线，卡片详情页也可以跳转到角色信息页面
2. 修复组队页面队伍多了之后卡顿的问题
3. 歌曲页面也添加了筛选和排序功能
4. 修复Nation Blue等歌曲的部分长按结束点异常的问题
5. 修复了一个非常罕见的因多线程引起的进入歌曲谱面或选歌时崩溃的bug
6. 修复純情Midnight伝説master难度缺失的问题
7. 卡详情页添加同角色所有卡片信息
8. 修复Groove活动中异色队伍的数值计算问题
9. 延长图片缓存的过期时间（原本只有一星期）
10. 修复谱面页面歌曲结束时的combo数有时不准确的问题(BEYOND THE STARLIGHT)
11. 缓存所有图片时，也会缓存角色头像
12. 多处界面细节优化

### v1.0.4
2016-8-29  

1. 卡片的筛选条件在退出时可以自动保存，筛选页面右上可以手工重置筛选条件
2. 修复按相册编号和或稀有度排序时闪退的问题
3. 修复多个页面右滑返回上一层的手势失效的问题
4. 修复首次进入谱面页面和每次进入生日提醒页面时卡顿的问题
5. 缓存图片时也可以看到缓存大小的变化
6. 修复有来电或手机作为热点时，队伍编辑时选人或选歌底部toolbar显示不全的问题
7. 缓存所有图片按钮的位置微调，防止误点
8. 选择队伍时，不必须点击空白处才能进入下一级菜单了
9. 优化组队编辑时文本编辑过于难点而且容易误点的问题
10. 略微增加歌曲难度按钮的高度
11. 优化技能列表的下拉箭头过于难点的问题

### v1.0.3
2016-8-21  

1. 优化本地数据存储，更新完毕后需要重新下载资源数据
2. 组队页面选人和选歌时添加返回按钮
3. 修复几处弹出菜单导致iPad上会闪退的问题
4. 卡片大图全屏化之后状态栏会隐藏
5. 缓存所有卡片大图改为缓存所有图片数据
6. 清理缓存的选项上也会显示当前缓存大小
7. 修复多处5s/se等机型上的文字显示问题
8. 修正iPad上多处表格内容和分割线的左右间隙过大的问题

### v1.0.2
2016-8-19  

1. 生日提醒功能正式开放，此功能默认关闭，请前往工具->偶像生日提醒中打开
2. 现在检查数据更新可以随时取消了
3. 设置页面可以选择是否在移动网络下缓存卡片大图(默认打开)
4. 设置页面可以一次性缓存所有卡片大图(下一个小版本中也可以缓存小头像和歌曲图)
5. 修复一部分歌曲 长按结束时是滑条的情况下 长按图示和滑条箭头重叠显示(比如tulip)
6. 微调卡片详情页面和组队详情页面的字体颜色和布局
7. 改善多种不同尺寸谱面页面的边界显示问题

### v1.0.1
2016-8-16  

1. 修复iPad和iPhone5s/se等机型上的显示问题
2. 修复设置页面评论功能无法正确跳转的问题
3. 改善谱面的显示(添加纵向辅助线 长按标记 优化滑条覆盖关系)
4. 改善组队编辑页面，没有特技和队长技的卡片可以正确显示了
5. 修复歌曲分数计算时，如果没有选择歌曲会导致无法再次计算的问题

### v1.0.0
2016-8-11  
