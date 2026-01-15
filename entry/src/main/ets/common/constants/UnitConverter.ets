/**
 * 度量衡换算常量
 */
export interface ConversionRate {
  chi: number; // 尺转厘米
  zhang: number; // 丈转厘米
  cun: number; // 寸转厘米
  jin: number; // 斤转克
  liang: number; // 两转克
  qian: number; // 钱转克
}

export interface Dynasty {
  id: string;
  name: string;
}

export interface Unit {
  id: string;
  name: string;
  type: 'length' | 'weight';
}

export const DYNASTIES: Dynasty[] = [
  { id: 'han', name: '汉代' },
  { id: 'tang', name: '唐代' },
  { id: 'ming', name: '明代' },
  { id: 'qing', name: '清代' },
  { id: 'modern', name: '现代' }
];

export const UNITS: Unit[] = [
  { id: 'chi', name: '尺', type: 'length' },
  { id: 'zhang', name: '丈', type: 'length' },
  { id: 'cun', name: '寸', type: 'length' },
  { id: 'jin', name: '斤', type: 'weight' },
  { id: 'liang', name: '两', type: 'weight' },
  { id: 'qian', name: '钱', type: 'weight' }
];

export function getConversionRate(dynastyId: string): ConversionRate | null {
  if (dynastyId === 'han') {
    return { chi: 23.1, zhang: 231, cun: 2.31, jin: 258, liang: 16.125, qian: 1.6125 };
  } else if (dynastyId === 'tang') {
    return { chi: 30.7, zhang: 307, cun: 3.07, jin: 596, liang: 37.25, qian: 3.725 };
  } else if (dynastyId === 'ming') {
    return { chi: 31.1, zhang: 311, cun: 3.11, jin: 590, liang: 36.875, qian: 3.6875 };
  } else if (dynastyId === 'qing') {
    return { chi: 32.0, zhang: 320, cun: 3.2, jin: 596, liang: 37.25, qian: 3.725 };
  } else if (dynastyId === 'modern') {
    return { chi: 33.3, zhang: 333, cun: 3.33, jin: 500, liang: 31.25, qian: 3.125 };
  }
  return null;
}
