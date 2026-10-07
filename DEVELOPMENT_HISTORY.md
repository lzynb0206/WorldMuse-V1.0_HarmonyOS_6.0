# WorldMuse Development History / 云览天下开发历程

> **Retrospective notice / 回溯说明**
>
> This document was reconstructed after the first complete release from the author's recollection, the current source tree, project documents, and product milestones. The dates below are approximate development dates rather than original Git commit timestamps. The list describes the sequence of work and does not claim that a Git commit was created on every listed date.
>
> 本文档在首个完整版本发布后，根据作者回忆、现有源代码结构、项目文档和产品节点进行回溯整理。下列日期是估算的开发时间，不是原始 Git 提交时间；它用于记录功能演进顺序，不表示每个日期都曾产生对应的 Git Commit。

## Overview / 概览

WorldMuse began as a native HarmonyOS museum-discovery application and gradually expanded into a cultural-learning platform containing museum and artifact browsing, personalized recommendations, itinerary planning, historical learning, gamified interactions, achievements, and utility tools.

云览天下最初定位为 HarmonyOS 原生博物馆探索应用，随后逐步扩展为涵盖博物馆与藏品浏览、个性化推荐、参观路线规划、历史学习、游戏化互动、成就系统和实用工具的文化学习平台。

| Stage | Approximate period | Focus |
| --- | --- | --- |
| 1 | 2025-01-06 — 2025-01-17 | HarmonyOS project foundation and navigation |
| 2 | 2025-01-20 — 2025-01-31 | Museum models, data, and list experience |
| 3 | 2025-02-03 — 2025-02-14 | Museum details and artifact data |
| 4 | 2025-02-17 — 2025-02-28 | Artifact search and filtering |
| 5 | 2025-03-03 — 2025-03-14 | Interest tags and local recommendations |
| 6 | 2025-03-17 — 2025-03-26 | Personal itinerary and drag sorting |
| 7 | 2025-03-31 — 2025-04-11 | Timeline, quiz, treasure hunt, and achievements |
| 8 | 2025-04-14 — 2025-04-23 | Utility pages, themes, and interface refinement |
| 9 | 2025-04-28 — 2025-05-05 | Release preparation and copyright materials |

## 阶段 1：HarmonyOS 工程初始化与页面导航

**估算时间：2025-01-06 — 2025-01-17**

这一阶段完成项目骨架、入口 Ability、页面注册和基础视觉规范，为后续模块开发提供统一基础。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-01-06 | `feat` 初始化 HarmonyOS 工程，搭建基础页面路由框架 |
| 2025-01-08 | `feat` 配置项目 Module，实现页面跳转导航 |
| 2025-01-10 | `fix` 修复页面栈跳转与返回异常问题 |
| 2025-01-13 | `refactor` 整理并封装全局导航逻辑 |
| 2025-01-15 | `docs` 补充项目说明与开发环境记录 |
| 2025-01-17 | `style` 统一全局基础样式与主题色定义 |

当前实现参考：`EntryAbility.ets`、页面配置、`Index.ets` 及应用级资源文件。

## 阶段 2：博物馆数据模型与列表

**估算时间：2025-01-20 — 2025-01-31**

建立博物馆领域模型和本地数据服务，完成首页博物馆内容展示以及列表体验的初步优化。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-01-20 | `feat` 定义博物馆实体数据模型 |
| 2025-01-22 | `feat` 完成博物馆首页列表界面开发 |
| 2025-01-24 | `feat` 接入本地博物馆数据源 |
| 2025-01-27 | `feat` 完善列表刷新和连续浏览体验 |
| 2025-01-29 | `fix` 优化列表图片加载时的视觉稳定性 |
| 2025-01-31 | `refactor` 整理博物馆列表项目的展示逻辑 |

当前实现参考：`MuseumModel.ets`、`MuseumService.ets`、`MuseumList.ets` 和 `Index.ets`。

## 阶段 3：博物馆详情与藏品数据

**估算时间：2025-02-03 — 2025-02-14**

从博物馆概览继续深入到详情和馆藏，通过藏品模型把博物馆、代表藏品和文化背景连接起来。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-02-03 | `feat` 开发博物馆详情页基础布局 |
| 2025-02-05 | `feat` 新增藏品数据模型并录入基础信息 |
| 2025-02-07 | `feat` 在博物馆详情页展示关联藏品 |
| 2025-02-10 | `feat` 完善藏品图片浏览体验 |
| 2025-02-12 | `perf` 优化详情页长内容滚动表现 |
| 2025-02-14 | `style` 优化详情页卡片布局与间距 |

当前实现参考：`ArtifactModel.ets`、`ArtifactService.ets`、`MuseumDetail.ets` 和 `ArtifactDetail.ets`。

## 阶段 4：藏品搜索和筛选

**估算时间：2025-02-17 — 2025-02-28**

为藏品数据增加主动发现能力，使用户能够通过关键词和分类条件快速缩小浏览范围。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-02-17 | `feat` 开发藏品搜索输入与交互 |
| 2025-02-19 | `feat` 实现藏品关键词模糊检索逻辑 |
| 2025-02-21 | `feat` 添加年代和藏品类型等筛选维度 |
| 2025-02-24 | `feat` 保存页面筛选状态 |
| 2025-02-26 | `fix` 修复搜索关键词清空后的状态异常 |
| 2025-02-28 | `refactor` 整理搜索和筛选业务逻辑 |

当前实现参考：`ArtifactExplore.ets`、`ArtifactService.ets` 和藏品数据模型。

## 阶段 5：兴趣标签与推荐算法

**估算时间：2025-03-03 — 2025-03-14**

引入用户兴趣标签和本地推荐服务。推荐逻辑通过比较用户标签与藏品标签的重合程度进行排序，并在结果不足时补充热门藏品。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-03-03 | `feat` 开发用户兴趣标签选择组件 |
| 2025-03-05 | `feat` 使用本地状态保存用户兴趣标签 |
| 2025-03-07 | `feat` 实现基于兴趣标签重合度的本地推荐算法原型 |
| 2025-03-10 | `feat` 开发首页推荐藏品卡片模块 |
| 2025-03-12 | `fix` 优化推荐结果排序与热门内容补充逻辑 |
| 2025-03-14 | `verify` 验证推荐逻辑并调试不同兴趣组合的结果 |

当前实现参考：`RecommendService.ets`、`InterestSelectPage.ets`、`RecommendPage.ets` 和 `RecommendListPage.ets`。

## 阶段 6：个人参观路线和拖拽排序

**估算时间：2025-03-17 — 2025-03-26**

把推荐结果进一步转化为可执行的参观计划，支持按博物馆组织藏品、调整顺序以及统计预计参观时间。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-03-17 | `feat` 创建个人参观路线页面 |
| 2025-03-19 | `feat` 实现藏品节点拖拽排序功能 |
| 2025-03-21 | `feat` 使用 AppStorage 保存自定义参观路线 |
| 2025-03-24 | `fix` 修复拖拽交互中的手势冲突 |
| 2025-03-26 | `style` 美化路线节点、分组和时间展示 |

当前实现参考：`MyItineraryPage.ets`、`RecommendPage.ets` 和 `RecommendListPage.ets`。

## 阶段 7：时间线、问答、寻宝与成就

**估算时间：2025-03-31 — 2025-04-11**

加入历史学习和游戏化功能，让博物馆内容从静态浏览扩展为时间线学习、知识问答、寻宝互动和成就反馈。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-03-31 | `feat` 开发文化历史时间线页面 |
| 2025-04-02 | `feat` 加入藏品与历史知识问答模块 |
| 2025-04-04 | `feat` 实现博物馆寻宝和打卡逻辑 |
| 2025-04-07 | `feat` 开发用户成就徽章系统 |
| 2025-04-09 | `fix` 修复打卡和进度状态的本地存储问题 |
| 2025-04-11 | `refactor` 整理游戏化模块的数据与业务逻辑 |

当前实现参考：`Timeline.ets`、`Quiz.ets`、`TreasureHuntPage.ets`、`Achievements.ets` 和 `GameService.ets`。

## 阶段 8：工具页面与界面优化

**估算时间：2025-04-14 — 2025-04-23**

补充设置和文化工具，并对主题、动画、布局适配和交互反馈进行集中整理。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-04-14 | `feat` 开发设置、历史日历、单位换算和取色器页面 |
| 2025-04-16 | `style` 完善全局主题与颜色适配 |
| 2025-04-18 | `perf` 优化页面动画与运行时资源使用 |
| 2025-04-21 | `fix` 调整不同设备尺寸下的页面布局 |
| 2025-04-23 | `style` 统一全局图标和交互反馈 |

当前实现参考：`SettingsPage.ets`、`ToolsPage.ets`、`CalendarToolPage.ets`、`UnitConverterToolPage.ets` 和 `ColorPickerToolPage.ets`。

## 阶段 9：应用发布与软件著作权材料

**估算时间：2025-04-28 — 2025-05-05**

完成首个可发布版本的构建、说明文档整理、发布前检查以及软件著作权申报材料准备。

| 估算日期 | 开发事项 |
| --- | --- |
| 2025-04-28 | `chore` 构建应用 Release 版本并检查打包配置 |
| 2025-04-30 | `docs` 撰写应用说明文档，准备软件著作权申请材料 |
| 2025-05-02 | `fix` 完成发布前最后一轮问题修复 |
| 2025-05-05 | `chore` 整理项目源码归档和软著申报材料 |

后续真实节点：计算机软件著作权登记日期为 **2025-12-09**。公开项目仅展示脱敏后的登记信息，不保存证书原始扫描件、证书号、完整登记号、条形码或二维码。

## Source Mapping / 源码映射

| Product area | Main implementation |
| --- | --- |
| App entry and navigation | `entryability/`, page profiles, `Index.ets` |
| Museums | `MuseumModel.ets`, `MuseumService.ets`, `MuseumList.ets`, `MuseumDetail.ets` |
| Artifacts | `ArtifactModel.ets`, `ArtifactService.ets`, `ArtifactExplore.ets`, `ArtifactDetail.ets` |
| Recommendations | `RecommendService.ets`, interest-selection and recommendation pages |
| Itinerary | `MyItineraryPage.ets`, AppStorage-backed itinerary state |
| Learning and games | Timeline, quiz, treasure-hunt, achievements, and game services |
| Utilities | Settings, calendar, unit converter, and color picker |

## Maintenance Note / 维护说明

Future development should be recorded through normal, current-date Git commits. If genuine historical snapshots, archived project versions, or IDE local-history records are recovered later, this retrospective document may be updated with verifiable implementation differences and sources.

后续开发应通过正常的当前日期 Git 提交记录。如果以后找回真实的历史快照、归档版本或 IDE Local History，可依据可验证的代码差异继续修订本文档。
