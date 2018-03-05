# ChangeLog

### 1.8.1
2018-3-5

1. 模拟 Groove 模式时，如果队伍可以获得生命回复效果，默认以双倍生命值开始，高级选项中可以关闭。
2. 修复 Note 列表中，过载技能没有算在 Combo 支援类别中的 Bug。
3. 改进数据更新机制，当有卡牌或角色数据变化时，无需手工清理缓存。

##### Japanese version

1.

##### English version

1. In groove, if you can gain healing effect, simulate with double hp at the beginning. This can be closed in advance options.
2. Fix a bug that overload skills are not listed as combo support.
3. Improve for data updating. When there are changes of cards or charas, no need to clear cached data manually.

### 1.8
2018-3-2

1. 支持三色协同技能。
2. 模拟算分中新增挂机模式模拟，原得分详情和辅助技能详情整合成 Note 列表。
3. 其他细节优化和 Bug 修复

##### Japanese version

1. シナジー系の特技を対応
2. スコア計算に放置モードを追加
3. 他の修正および改善

##### English version

1. Support for new skill type "Synergy".
2. Support for AFK mode in live simulator.
3. Other fixes and improvements.

### 1.7.5
2018-2-1

1. 修复获取模拟抽卡数据经常失败的问题。
2. 修复更新数据时的动画错误。
3. 修复自动播放谱面时，时间显示错误。

##### Japanese version

1. ガシャシミュレーターに常にデータ更新失敗する不具合を修正
2. データ更新時アニメーションの不具合を修正
3. 譜面の自動再生時、時間表示の不具合を修正

##### English version

1. Fix a bug that loading gacha data often fails.
2. Fix loading indicator's animation.
3. Fix a bug that sometimes beatmap player shows wrong current time.

### 1.7.4
2018-1-31

1. 增加新活动类型。
2. 修复一个可能导致启动时崩溃的问题。

##### Japanese version

1. 新しいイベントタイプの対応
2. 起動時に強制終了できるバグを修正

##### English version

1. Add new event type.
2. Fix a crash problem at launching.

### 1.7.3
2018-1-22

1. 恢复模拟抽卡功能。
2. 提升模拟算分速度。

##### Japanese version

1. ガシャシミュレーターの機能復旧
2. シミュレート計算のパフォーマンス改善

##### English version

1. Gacha Simulator is back.
2. Improve performance of Live Simulator.

### 1.7.2
2018-1-16

1. 优化模拟算分模型，计算更准确，但是计算速度有所下降。
2. 支持编辑生命值潜能，寻求组队中支持根据生命值潜能最小值筛选。
3. 修复几处细微的动画效果问题。

##### Japanese version

1. シミュレート計算にアルゴリズム（計算パターン）を改善。計算は更に時間を掛かりますが、計算精度は上回りになりました
2. ポテンシャル編集はライフの編集を対応（同僚募集のスクリーニングも対応）
3. UIアニメーションについて数箇所の修正

##### English version

1. Improve live simulator model, result is more accurate, but with a lower speed.
2. Support for editing life potential. Colleague Finder also supports filtering by minimum life potential.
3. Fix some subtle animation problem.

### 1.7.1
2018-1-7

1. 增加对新技能的支持。
2. 更新图片服务器地址。
3. 其他细节优化。

##### Japanese version

1. 新しい特技・センター効果の対応
2. 新しい画像サーバーへ移行
3. 他の機能向上

##### English version

1. Add support for new skills.
2. Update image server.
3. Other improvements.

### 1.7
2017-11-25

1. 新增谱面自动播放功能。
2. 谱面支持通过手势进行缩放。
3. 修复卡片列表按更新时间排序时顺序错乱的问题。
4. 修复当调整系统文本大小时，部分页面显示错误的问题。
5. 调整部分技能类型的名称，保持和官方统一。
6. 其他细节优化和 Bug 修复。

##### Japanese version

1. 譜面の自動再生機能を追加
2. 譜面ページにジェスチャーで縦向きスケーリングすることができるようになります
3. カード一覧に更新時間で並べ替える時、表示順番が間違ってるバグを修正
4. システム設定で文字の大きさを変更することによる、一部のページの表示は間違ってるバグを修正
5. 公式と一致にするため、一部の特技タイプの名前を変更します
6. 他の機能向上とバグ修正

##### English version

1. Add beatmap player.
2. Beatmaps now support for pinch gesture to scale.
3. Fix the bug when sorting by update time, card list is always disorderly.
4. Fix that after setting system font size, some pages will display in error and crash.
5. Keep the name of some skill types the same as the formal's.
6. Other bug fixes and improvements.

### 1.6.4
2017-11-7

细节优化和 Bug 修复。

##### Japanese version

機能向上とバグ修正

##### English version

Bug fixes and improvements.


### 1.6.3
2017-11-2

1. 针对近期无法获取卡片概率的卡池，**暂时**去除模拟抽卡的功能。
2. 适配 iPhone X，页面布局优化。

##### Japanese version

1. 近日中に開催してるガシャが自動で確率を取得できませんのため、対象のガシャを**一時的**、ガシャシミュレーター機能の利用を制限します
2. iPhone Xに対応します、及びページレイアウトの向上

##### English version

1. For gachas those can not get each card's rate, **temporarily** remove its gacha simulator.
2. Support iPhone X and UI improvements.


### 1.6.2
2017-10-29

1. 修复活动页面详情可能闪退，以及分数榜显示错误的问题。
2. 修复计算 TRICK 难度歌曲得分时闪退的问题。

##### Japanese version

1. イベント詳細ページに強制終了されるバグ及びランキング表示の不具合を修正
2. スコア計算に難易度TRICKの譜面で計算する時アプリが強制終了されるバグを修正

##### English version

1. Fix crash and high score ranking display error on event detail page.
2. Fix crash when calculate with beatmaps of TRICK difficulty.


### 1.6.1
2017-10-25

1. 新增谱面选项，支持类似游戏中 TYPE 3/4 的颜色方案。
2. 专注技能描述和分数加成数值修改。（需要您接受启动时建议更新的提示，或手工下拉刷新数据）
3. 极限分数考虑新专注技能带来的影响，结果更加准确。
4. 使用 Starlight Portal 作为新的活动档位查询数据源。

##### Japanese version

1. 譜面確認ページにオプションを追加：ゲーム内のTYPE 3/4と類いカラーリングを選択できるようになります
2. 特技「コンセントレーション」の説明テキストとボーナス値の変更（データの更新は必要となります）
3. スコア計算に極限スコアの算出パターンは特技「コンセントレーション」新効果を対応しています、結果はさらに精確となります
4. Starlight Portalはイベントランキング・ボーダーの新しいデータ提供元として採用されます

##### English version

1. New beatmap settings, support note colors like in-game settings type 3 / 4.
2. Update concentration skills' description. (data update at launching or manually pull to refresh is needed)
3. Concentration skills are taken into consideration in optimistic score 1.
4. Use "Starlight Portal" as the new event data source.

### 1.6
2017-10-17

1. 新增歌曲信息页面，可以查看歌曲详情及 MV 站位等。
2. 卡片和角色信息详情中可以查看角色出演过哪些 MV。
3. 支持 SMART LIVE 谱面的查看和导出。
4. 优化谱面筛选功能，现在可以自定义需要显示的谱面难度。
5. 修复部分谱面长按和滑条绘制错误的问题。
6. 修复当系统的时间设置中 24 小时制未勾选时，可能导致活动和卡池详情页面的时间显示错误的问题。
7. 长按手势加入震动反馈（仅支持含 3D Touch 的机型）。
8. 优化所有页面的下拉刷新和上拉加载更多，不再卡顿或者跳动。

##### Japanese version

1. 楽曲情報ページを追加：楽曲の詳細情報とMVポジションなどを確認できるようになります
2. カード・キャラの詳細情報に楽曲MV出演の情報を確認できるようになります
3. SMART LIVEの譜面を対応します
4. 譜面の絞り込み機能の向上：今は表示したい難易度をカスタマイズできるようになります
5. 一部の譜面で長押しとスライドの描画不具合を修正
6. 日本語端末のシステム設定で「24時間表示」を切っている場合、イベントやガシャ情報に表示された時間が間違ってるバグを修正
7. 長押しのジェスチャーに振動のフォースフィードバックを追加（3D Touch対応機種のみ）
8. すべてのページに「プルダウン／アップで再読み込み」操作のパフォーマンス向上

##### English version

1. Add music info page that shows detail information of songs, and position of charas in music video.
2. Add music videos those the current chara is starred in on card detail page and chara detail page.
3. Add support for displaying SMART LIVE beatmap and exporting.
4. Improve beatmap filter, now you can custom the difficulties you want to show at the list.
5. Fix for some long press and slide note are not drawn currectly.
6. Fix a bug when your device's setting "24 hour time" is disabled, the date in event and gacha page will always show the current time.
7. Add vibration feedback for long press gesture.
8. Redesign all "pull to refresh" and "load more", they will not lag or jump.

### 1.5.4
2017-10-3

修复进入卡片详细页面时发生的崩溃。

##### Japanese version

カード詳細ページを開こうするとアプリが強制終了する不具合を修正

##### English version

Fix a crash occurred when entering card detail page.

### 1.5.3
2017-9-29

修复“支持我们”中的内购项目。

##### Japanese version

「開発者を応援する」ページのアプリ内課金アイテムの修正

##### English version

Fix iAP items in "Support us" page.

### 1.5.2
2017-9-27

1. 修复 iOS 11 下保存图片时闪退的问题。
2. 修复可能导致启动时闪退的一个问题。
3. 为了减少安装包体积，提升用户体验，“支持我们”页面中不再嵌入象征性的广告。

##### Japanese version

1. iOS 11で画像を保存する時アプリが強制終了するバグを修正
2. 特定条件でアプリ起動時に強制終了する不具合を修正
3. アプリのサイズを減って、より優れた利用体験を提供しようとするために、「開発者を応援する」ページの広告は廃止されます

##### English version

1. Fix a crash when add image to system photos.
2. Fix a potential crash at launching.
3. To reduce the size of the install package and make the app better, we remove the symbolic advertisement in "Support us" page.

### 1.5.1
2017-9-20

1. 修复点击完整卡池列表时闪退的问题。
2. 修复用 BPM 排序谱面时闪退的问题。
3. 修复 iPad 寻找同僚，输入自己 ID 时键盘遮挡按钮，且页面无法关闭的问题。
4. 修复部分可能导致启动时闪退的问题。
5. 修复一些 iOS 11 下页面布局错误的问题。

##### Japanese version

1. ガシャ画面にアイドル一覧をタッチしてアプリが強制終了するのバグを修正
2. BPM順で楽曲を並べ替える時アプリが強制終了するのバグを修正
3. iPadで同僚募集機能を利用している時、ID入力画面にソフトキーボードが続行ボタンを遮っているし、戻ることもできないのレイアウトの不具合を修正
4. iOS 11で一部のページでレイアウトの不具合を修正

### 1.5
2017-9-15

**此版本起，更名为 DereGuide**
1. 寻找同僚功能正式上线。
2. 技能的详细说明支持日文和英文版本。
3. 适配 iOS 11。
4. 优化谱面页面的性能。
5. 修复组队数据无网络时可能丢失的问题。
6. 其他细节优化和 Bug 修复。

##### Japanese version

**このバージョンから、CGSSGuideのアプリ名はDereGuideに変更しました**
1. 同僚募集の機能を追加します
2. 特技・センター効果の説明テキストは数値のもとにテンプレート（定型文）を使用するようになります
3. iOS 11に対応します
4. 譜面ページのパフォーマンス向上
5. ユニットデータがネットワーク未接続の場合に紛失可能のバグを修正
6. 他の機能改善とバグ修正

##### English version
1. Add Colluague Finder.
2. Add localization for skills and center skills' description.
3. Adaptation for iOS 11.
4. Improve the performance of beatmap page.
5. Fix a bug that units may disppear when lauching with no internet connection.
6. Other improvements and bug fixes.

### 1.4.4
2017-8-10

1. 修复模拟抽卡页面点击新卡图标时闪退的问题。
2. 修复组队详情页面翻转后停留在错误的分页。

##### Japanese version

1. ガシャシミュレーターで新アイドルのカードのアイコンをクリックしている時アプリが強制終了のバグを修正
2. ユニット情報ページでローテーション行った後間違いダブを表示するバグを修正

##### English version

1. Fix a crash when clicking at card icon on gacha detail page.
2. Fix a layout issue when orientation changed on team detail page.

### 1.4.3
2017-8-3

1. 喜欢的角色和卡片也纳入 iCloud 同步。
2. 优化和 Bug 修复。

##### Japanese version

1. お気に入ったアイドルとカードもiCloudに同期できるようになります
2. 機能改善とバグ修正

##### English version

1. Favorite cards and characters auto sync to iCloud.
2. Improvements and bug fixes.

### 1.4.2
2017-7-28

1. 缩小一些页面横屏模式下的宽度，更适合阅读。
2. 角色信息页面排序时也会显示当前排序属性的数值。
3. 模拟抽卡页面增加天井卡片列表，累计抽卡次数等信息。
4. 修复部分活动曲谱面和难度不匹配的问题。
5. 组队数据自动同步至 iCloud（当您的设备处于 iCloud 登录状态，此功能自动开启。切换 iCloud 账号，组队数据也随之切换。如果您的多个设备都登录了同一个 iCloud 账号，设备间数据共享。）。
6. 针对图片下载失败的情况（卡片大图，卡池图，活动图等），现在双击可以重新下载
7. 增加隐私政策页面，即将添加的新功能可能会收集您使用本程序过程中产生的一些数据，如模拟时组建的队伍，喜欢的卡片和角色等。

##### Japanese version

1. 快適に閲覧のため、横画面に一部ページの幅を縮めます
2. キャラ一覧ページにソート（並べ替え）を行っている時、利用している条件に対応する数値もリストに表示します
3. ガシャシミュレーターに天井リストとガシャる回数の表示を追加します
4. 一部のイベント楽曲の難易度と対応する譜面は一致しませんの不具合を修正
5. ユニットデータはiCloudサーバーに経由して自動同期するようになります（iCloudアカウントごとに同期・共有します）
6. 単独の画像（フルサイズ/ガシャヘッダー/イベントヘッダー など）にダブルタップして、画像が再ダウンロードできるようになります
7. プライバシーポリシーを追加します。将来の新機能のため、お客様がアプリ利用の過程に一部のデータ（編成したユニットや、お気に入ったカードとアイドルなど）を採取・アップロードすることがあります

##### English version

1. Make it more readable in landscape mode by reducing the width of some pages.
2. Chara info page also show sorting property at right side.
3. Add 300-pull guaranteed cards and simulation statistics in gacha simulation page.
4. Fix that some beatmaps mismatching with their difficulties.
5. Unit data auto sync to iCloud.
6. Double click can reload the spread image of card, gacha header and event header.
7. Add privacy policy page, the feature will be added in the near future may collect data such as the units you created, favorite cards and charas.

### 1.4.1
2017-7-6

1. 所有页面支持横屏模式。
2. 优化组队编辑页面。
3. 其他 Bug 修复。

##### Japanese version

1. 横画面表示を対応します
2. ユニット編集画面の改善
3. 他のバグ修正

##### English version

1. Support for landscape mode.
2. Improve unit editing page.
3. Other bugs fixed.

### 1.4.0
2017-6-24

1. 大幅改进组队编辑页面，可以快速选择使用过的偶像，编辑同一角色所有卡片的潜能。
2. 组队模拟增加高级计算，可以根据模拟结果进行更加详细的计算。
3. 修复更新数据时闪退的问题。

##### Japanese version

1. ユニット編集画面の大きな機能向上：最近に使うアイドルをクィック選択、ポテンシャル一括編集などの機能を追加します
2. スコア計算にアドバンス計算を追加：シミュレート結果をもとにさらに詳しくの計算を行うことができます
3. データ更新時アプリが強制終了する問題を修正

##### English version

1. Improve team edit page, you can select recent used idols and edit all the same chara's potential more conveniently.
2. Add advance calculation to team simulation, you can use the simulation result to do more in-depth calculation.
3. Fix crash when updating data

### 1.3.3
2017-6-7

1. 修复组队页面闪退问题

##### Japanese version

1. ユニット編成ページでアプリが強制終了するバグを修正

##### English version

1. Fix crash on entering team tab.

### 1.3.2
2017-6-6

1. 反馈方式增加 Twitter。
2. 修复公主系列队长技能对队伍表现值加成错误的问题。
3. 组队模拟中新增得分分布图，同时还增加了更多高级选项。

##### Japanese version

1. フィードバック方式追加：Twitter
2. プリンセス系センター効果のアピール加算に不具合が発生するバグを修正
3. スコア計算にスコア確率分布グラフを追加します、アドバンスオプションも拡張します

##### English version

1. Add Twitter as a new way to feedback.
2. Fix wrong team appeal when leader skill is one of princess series skills.
3. Add a score distribution chart and more advance options for team simulation.

### 1.3.1
2017-5-31

1. 修复生日通知中没有角色头像的问题。
2. 修复队伍表现值在彩色歌曲下计算错误的问题。
3. 修复得分详情和辅助技能详情页面选择模式时崩溃的问题。

##### Japanese version

1. 誕生日通知にキャラアイコンは表示できないバグを修正
2. スコア計算にユニットの全タイプ曲アピールの加算に不具合が発生するバグを修正
3. スコア計算に得点情報と他の特技情報のページがモードを選択する時アプリが強制終了するバグを修正

##### English version

1. Fix bug that birthday notification right side has no chara icon.
2. Fix wrong team appeal in all-type songs.
3. Fix score detail and support skills detail page mode selection button crashing in iPad.


### 1.3.0
2017-5-26

**此版本起，不再支持低于 iOS 9.0 的设备**
1. 优化模拟组队页面布局。
2. 增加强判、护盾、回血等辅助技能的模拟详情页面。
3. 优化算法，提高平均分数计算的准确性。
4. 增加高级选项，可以选择是否在模拟计算中考虑过载技能的发动条件。
5. 生日提醒通知内容中增加角色图标，并且支持 3D Touch 展开（iOS 10+）。
6. 歌曲页面可以对指定难度进行筛选，可以根据note数或难度星级排序。
7. 完整可抽列表中增加按照获取几率排序。
8. 组队列表页中，队伍顺序变得可以调整了。

##### Japanese version

**このバージョンから、iOS 9.0以下はサポート対象外です**
1. 模擬ユニット編成のレイアウト向上
2. 判定強化などのサポート系特技の発動情報ページを追加します
3. 平均スコアの精度について算法向上
4. アドバンスオプションを追加：シミュレート計算にオーバーロードの発動条件の考えているかどうか、選択できるようになります
5. 誕生日通知にキャラアイコンを追加、3D Touchの展開操作も対応します（iOS 10+）
6. 楽曲ページに難易度のスクリーニング（絞り込み）条件、及びnote数・難易度レベルのソート（並べ替え）条件を追加
7. ガシャの出現アイドル一覧に排出率のソート（並べ替え）条件を追加します
8. マイユニットのページに、ユニットの順番は編集できるようになります

##### English version

**Does not support devices below iOS 9.0 by this version**
1. Improve ui design of team simulation page.
2. Add simulation detail for perfect lock, guard and heal skills.
3. Improve algorithm of calculation, average score will be more accurate.
4. Add advance option for simulation for considering overload skills trigger condition.
5. Birthday notification now has a chara icon and can be 3d touched (only for iOS 10+).
6. Song page can be filtered by specific difficulties, and can be sorted by number of notes or difficulty stars.
7. Full available list can be sorted by obtaining chance of card.
8. Teams in team list page are movable now.

### 1.2.7
2017-4-11

1. 巡演活动页面中，增加了查看每日流行曲的功能。
2. 修复“极限分数1”有时会不准确的问题。
3. 多处性能优化。

##### Japanese version

1. LIVE Paradeのイベント情報ページに日替わり流行曲リストを見ている機能を追加します
2. 極限スコア1の計算にたまに誤差を出てるバグを修正
3. 幾つかのパフォーマンス向上

##### English version

1. Add bonus song info in live parade event page.
2. Fix that sometimes optimistic score 1 is not correct.
3. Many other improvements.


### 1.2.6
(released with 1.2.7)

1. 增加对新技能类型“Cute/Cool/Passion 集中”的支持。
2. 模拟算分增加查看得分详情的功能。
3. 针对官方提供准确几率的卡池，查看完整可抽列表页面现在也显示每张卡的实际几率。
4. 修复 2017/3/28 的 Fes 卡池几率不准确问题。
5. 修复队伍中存在“技能增强”类特技时，直接计算的平均分数不准确的问题。
6. 新增app内评分的功能（iOS 10.3+）。

##### Japanese version

1. 近日中に追加された「フォーカス系」の新しい特技を対応します
2. スコア計算に得点情報ページを追加します
3. 追加：ガシャシミュレーターの出現アイドル一覧にカードごとの出現率を表示します
4. ガシャシミュレーターに2017-3-28で開催されたfes限定ガシャの確率不具合を修正
5. スコア計算にユニットに「スキルブースト」などの特技を存在しているとき、通常計算で算出された平均スコアは誤りましたバグを修正
6. アプリ内評価の機能を追加します(iOS 10.3+)

##### English version

1. Support for new skill type series "Focus".
2. Add score detail page for live simulator.
3. For the gacha pools those have accurate rate of each card, full available list page now shows the rate.
4. Fix 2017/3/28 CinFes gacha pool's wrong rate.
5. Fix that in live simulator average score displays wrong result when has skill boost member in team.
6. Add In-app rating feature(only for iOS 10.3+).

### 1.2.5
2017-3-30

1. 增加对“技能增强”类型特技的支持。
2. 模拟算分增加对技能发动几率提高类型队长技的支持。
3. 卡片首页和 HomeScreen 图标增加 3D Touch 支持。
4. 谱面页面增加一个可拖动滑块，方便快速定位。
5. 点击生日通知可以直接跳转到角色信息页面。
6. 细节优化和 Bug 修复。

##### Japanese version

1. 近日中に追加された「スキルブースト」の新しい特技を対応します
2. スコア計算に特技発動確率アップ系のセンター効果を対応します
3. カードページとホーム画面に3D Touchの操作を対応します
4. 便利のため、譜面確認ページにスクロールウィジェットを追加します
5. 追加：通知センターのアイドル誕生日の通知は、対応するキャラクターのページへ移動の操作を行います
6. 細い機能向上とバグ修正

##### English version

1. Add support for new skill type "Skill Boost".
2. Add support for proc chance leader skills in live simulator.
3. Add 3d touch for card page and home screen icon.
4. Add a slider in beatmap page.
5. Clicking on birthday notifications will navigate to the character page.
6. Other bug fix and improvements.

### 1.2.4
2017-2-24

1. 卡片信息，卡片筛选和组队模拟中增加对 All Round（全才）等新技能的支持。
2. 增强组队模拟中得分计算的功能，平均分计算不再使用模拟法。
3. 谱面中新增 BPM 改变信息，修复大部分未对齐的谱面。

##### Japanese version

1. 近日中に追加された「オールラウンド」などの新しい特技を対応します
2. マイユニットのスコア計算機能を改善します。平均スコアの計算はシミュレート法を使用しなくなりました
3. 譜面確認ページに変化bpmの情報を追加します、以前未対応の譜面も対応しています

##### English version

1. Support for "All Round" and other new kinds of skill in card information, card filter and team simulation page.
2. Improve team simulation and calculation feature, average score use calculation instead of simulation algorithm.
3. Add bpm shifting information for some beatmaps, fix most not aligned beatmaps.

### 1.2.3
2017-2-15

1. 增加对新类型 Note 的支持。
2. 歌曲列表排序方式改为默认按最后变更时间，原“更新时间”改为“首次出现时间”。

##### Japanese version

1. 新しいノーツタイプを対応します
2. 楽曲ソートのデフォルト方式は最後の変更時間に変更します、元の「更新時間」は「初登場時間」に変更します

##### English version

1. Add support to new type of note.
2. Change the default songs sorting method from "Update time" to "Last updated time", and the old "Update time" now is "Created time".

### 1.2.2
2017-2-13

1. 修复缓存所有图片计数不准确的问题。
2. 修复多线程访问数据库导致崩溃的问题。
3. 其他 Bug 修复。

##### Japanese version

1. 画像キャッシュのカウンターが誤った数値を表示するバグを修正
2. データベースをマルチスレッドアクセスでアプリが強制終了するバグを修正
3. 他のバグ修正

##### English version
1. Fix a bug of "cache all images" page displaying wrong numbers.
2. Fix crash caused by multi-thread accessing to database.
3. Other bugs fixed.

### 1.2.1
2017-2-9
1. 活动和卡池页面的时间从日本时间改为本地时间。
2. 优化致谢和版权声明页面。
3. 优化缓存所有图片功能。
4. 其他 Bug 修复。

##### Japanese version
1. イベント・ガシャページにおける時間表記をローカル時間に表示するようになります
2. クレジット・権利表記ページの機能向上
3. 画像キャッシュの機能向上
4. 他のバグ修正

##### English version
1. Use local time instead of Tokyo time in event and gacha information page.
2. Improve Acknowledgement and Copyright page.
3. Improve the feature of caching all images.
4. Other bugs fixed.


### 1.2.0
2017-1-31

1. 优化筛选和排序页面，现在可以通过手势从右侧滑出。
2. 新增工具 - 活动信息查询，包含活动卡、歌曲、活动实时档位等信息。
3. 新增“支持我们”页面，如果您喜欢这款应用，请支持我们。
4. 新增技能发动间隔、技能触发几率、来源等卡片筛选条件。
5. 新增人物3D模型、签名图、卡片图的查看功能。
6. 修复一部分非限定 SR 卡被标记为限定卡的问题。

##### Japanese version
1. フィルタ（絞り込み）とソート（並べ替え）における機能向上、画面右側からのスワイプでスクリーニングメニューを呼び出せるようになります
2. 便利ツールにイベント情報一覧の機能を追加：イベントの限定カード、楽曲、リアルタイムランキングを見ることができます
3. 「開発者を応援する」ページを追加：このアプリを気に入った方は寄付する形で私たちに応援できるようになります
4. カード検索のフィルター（絞り込み）にて以下の条件を追加：スキル発動間隔、スキル発動確率、入手方法など
5. キャラクター3Dモデル、サイン画像、カード画像を見ている機能を追加します
6. 一部の非限定Sレアカードが限定として表記されるバグを修正

##### English version
1. Improve sort and filter page, now it can be slid from the right side.
2. Add event information to tools tab, including event cards, song, ranking information.
3. Add "support us" page, if you like this application, please support us.
4. Add skill interval, skill proc rate, source as card filter methods.
5. Add 3D model, sign image, card image viewing page.
6. Fix the problem that some normal SR cards tagged as limited.

### 1.1.5
2016-12-11

1. 组队页面增加批量删除和复制功能。
2. 完善模拟队伍算分和模拟抽卡的说明文字。
3. 修复查看歌曲闪退的问题。如果某些谱面为空，请您尝试清除歌曲缓存后再重新下载。
4. 修复新付声角色在更新后仍然无法显示 CV 的问题。

##### Japanese version
1. マイユニットのタブでバッチ削除・コピーができるようになります
2. スコア計算とガシャシミュの説明テキストを補足します
3. 譜面を確認した時アプリが強制終了するバグを修正（互換性のため、一度楽曲のキャッシュをクリアしてください）
4. CV実装したキャラが更新した後、CVが表示されないのバグが修正
5. 日本語翻訳の語彙を調整（<データを>アップデート -> 更新）

##### English version
1. Add mass copy and delete for team editing.
2. Add addition description for gacha simulation and team simulation.
3. Fix crash problem while entering beatmap page. If some beatmaps are still empty, please remove cache data and download again.
4. Fix the problem that characters with newly added cv cannot be updated to display the cv name.


### 1.1.4
2016-11-1

1. 优化谱面页面的 FPS。
2. 模拟抽卡中所有卡的概率改为和官方公布的概率一致。
3. 角色可以按照生日和 BMI 排序。

##### Japanese version
1. 譜面ページの流暢さ（FPS）を改善
2. ガシャシミュレーターで提供割合は公式の数値を採用します
3. アイドル検索で二つのフィルタ（絞り込み条件）を追加：誕生日・BMI値

##### English version
1. Improve fps performance when scrolling beatmap.
2. Gacha simulation now have the same rate for each card as the formal data.
3. Character can be sorted by birthday and BMI.

### 1.1.3
2016-10-12

1. 增加清理缓存的二级页面，可以分类清除。近期部分谱面数据出错，请您尝试使用此功能手工清理再重新下载。
2. 优化谱面导出功能，统一不同设备导出谱面的规格。
3. 修复 iPad 导出谱面崩溃的问题。
4. 增加了一个耗时任务提示框。

##### Japanese version
1. キャッシュクリアが分類ごとでクリアすることができるようになります（最近の譜面データは誤り点がありますので、一度削除してください）
2. 譜面画像の保存の機能向上
3. iPadで譜面画像の保存時クラッシュする問題を修正
4. 一部のプロセスがポップアップボックスを付いているようになります

##### English version
1. Add English localization(thanks to summertriangle-dev).
2. Add category for data wiping. You can use this feature to remove wrong data manually and download again.
3. Improve beatmap exporting feature, and export the same image on different devices.
4. Fix crash when exporting beatmap on iPad.
5. Add a "please wait" hud when processing task.

### 1.1.2
2016-10-4

1. 谱面页面新增镜像翻转的功能。
2. 歌曲得分计算增加对 LIVE Parade 模式的支持。
3. 歌曲筛选活动类型增加 LIVE Parade 模式。
4. 修正系统语言设置为繁体中文 - 台湾时, 部分本地化字符串不生效的问题。

##### Japanese version
1. 譜面ビューアーでミラージュ機能を追加します
2. LIVEスコアの計算にLIVE Paradeモードを追加します
3. 楽曲検索でLIVE Paradeのフィルタ（絞り込み条件）を追加します
4. 繁体字中国語で一部ローカライズされた文字列が反映されませんの問題を修正します

### 1.1.1
2016-10-1

1. 添加对繁体中文和日文支持（根据设备默认语言自动选择）。
2. 修复三色队在 Groove 中去掉队友队长后不能触发自己队长的达成条件时，错误的仍然按照触发了队长技能计算表现值的问题。
3. 模拟抽卡页面增加卡池中各稀有度的几率。

##### Japanese version
1. 中国語繁体字と日本語向けにローカライズします
2. fesアイドルがユニットセンターになる時、センター効果の発効条件が設置されたゲストアイドルをまとめ誤って判定して、Grooveのスコア計算を違った結果を出す問題を修正
3. ガシャシミュレーターのUIで提供割合を表示します

### 1.1.0
2016-9-23

1. 工具 - 模拟抽卡正式上线。
2. 队伍编辑页面新增对潜能解放的支持。
3. 卡片详情页面添加卡片的获取途径。
4. 生日提醒页面显示当前系统是否允许 App 通知。
5. 当页面层级过多时，底部会出现一个返回主页的按钮。
6. 大量界面细节优化。

### 1.0.6
2016-9-14

1. 修复计算打歌平均分数时没有考虑偶像和歌曲（或 Groove 颜色）同色时技能触发几率提高 30% 的因素（感谢吧友timeseal）。
2. 改进计算技能触发几率和持续时间的算法（感谢吧友 statementreply）。
3. 修复 iOS 9.0 之前的系统进入偶像生日提醒时崩溃的问题。
4. 卡片页面添加按技能类型筛选。
5. iPhone 6 之后的手机和所有的 iPad 上，卡片列表中也可以看到技能持续时间和触发几率。
6. 修复双叶杏的星座描述文字。
7. 生日提醒中的角色头像也可以跳转到角色信息页面。

### 1.0.5
2016-9-8  

1. 工具 - 角色信息查询正式上线，卡片详情页也可以跳转到角色信息页面。
2. 修复组队页面队伍多了之后卡顿的问题。
3. 歌曲页面也添加了筛选和排序功能。
4. 修复 Nation Blue 等歌曲的部分长按结束点异常的问题。
5. 修复了一个非常罕见的因多线程引起的进入歌曲谱面或选歌时崩溃的 Bug。
6. 修复純情Midnight伝説 Master 难度缺失的问题。
7. 卡详情页添加同角色所有卡片信息。
8. 修复 Groove 活动中异色队伍的数值计算问题。
9. 延长图片缓存的过期时间（原本只有一星期）。
10. 修复谱面页面歌曲结束时的 Combo 数有时不准确的问题（BEYOND THE STARLIGHT）。
11. 缓存所有图片时，也会缓存角色头像。
12. 多处界面细节优化。

### 1.0.4
2016-8-29  

1. 卡片的筛选条件在退出时可以自动保存，筛选页面右上可以手工重置筛选条件。
2. 修复按相册编号和或稀有度排序时闪退的问题。
3. 修复多个页面右滑返回上一层的手势失效的问题。
4. 修复首次进入谱面页面和每次进入生日提醒页面时卡顿的问题。
5. 缓存图片时也可以看到缓存大小的变化。
6. 修复有来电或手机作为热点时，队伍编辑时选人或选歌底部 Toolbar 显示不全的问题。
7. 缓存所有图片按钮的位置微调，防止误点。
8. 选择队伍时，不必须点击空白处才能进入下一级菜单了。
9. 优化组队编辑时文本编辑过于难点而且容易误点的问题。
10. 略微增加歌曲难度按钮的高度。
11. 优化技能列表的下拉箭头过于难点的问题。

### 1.0.3
2016-8-21  

1. 优化本地数据存储，更新完毕后需要重新下载资源数据。
2. 组队页面选人和选歌时添加返回按钮。
3. 修复几处弹出菜单导致 iPad 上会闪退的问题。
4. 卡片大图全屏化之后状态栏会隐藏。
5. 缓存所有卡片大图改为缓存所有图片数据。
6. 清理缓存的选项上也会显示当前缓存大小。
7. 修复多处 5s/se 等机型上的文字显示问题。
8. 修正 iPad 上多处表格内容和分割线的左右间隙过大的问题。

### 1.0.2
2016-8-19  

1. 生日提醒功能正式开放，此功能默认关闭，请前往工具 - 偶像生日提醒中打开。
2. 现在检查数据更新可以随时取消了。
3. 设置页面可以选择是否在移动网络下缓存卡片大图（默认打开）。
4. 设置页面可以一次性缓存所有卡片大图（下一个小版本中也可以缓存小头像和歌曲图）。
5. 修复一部分歌曲，长按结束时是滑条的情况下，长按图示和滑条箭头重叠显示（比如 Tulip）。
6. 微调卡片详情页面和组队详情页面的字体颜色和布局。
7. 改善多种不同尺寸谱面页面的边界显示问题。

### 1.0.1
2016-8-16  

1. 修复 iPad 和 iPhone 5s/se 等机型上的显示问题。
2. 修复设置页面评论功能无法正确跳转的问题。
3. 改善谱面的显示（添加纵向辅助线、长按标记、优化滑条覆盖关系）。
4. 改善组队编辑页面，没有特技和队长技的卡片可以正确显示了。
5. 修复歌曲分数计算时，如果没有选择歌曲会导致无法再次计算的问题。

### 1.0.0
2016-8-11  
