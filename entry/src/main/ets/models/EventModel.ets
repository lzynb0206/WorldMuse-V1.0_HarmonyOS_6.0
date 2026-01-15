/**
 * 历史事件数据模型
 */
export interface HistoricalEvent {
  month: number; // 月份 1-12
  day: number; // 日期 1-31
  year: number | null; // 年份，null表示每年重复
  title: string; // 事件标题
  desc: string; // 事件描述
  artifactId: number; // 关联的藏品ID
}

