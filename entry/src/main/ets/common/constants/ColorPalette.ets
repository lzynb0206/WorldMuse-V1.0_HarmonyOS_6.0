/**
 * 宫廷颜色库
 */
export interface RgbColor {
  r: number;
  g: number;
  b: number;
}

export interface ColorInfo {
  name: string;
  hex: string;
  rgb: RgbColor;
}

const color1: ColorInfo = { name: '故宫红', hex: '#C81A1A', rgb: { r: 200, g: 26, b: 26 } };
const color2: ColorInfo = { name: '琉璃黄', hex: '#E8B923', rgb: { r: 232, g: 185, b: 35 } };
const color3: ColorInfo = { name: '天青', hex: '#4A90E2', rgb: { r: 74, g: 144, b: 226 } };
const color4: ColorInfo = { name: '翡翠绿', hex: '#2ECC71', rgb: { r: 46, g: 204, b: 113 } };
const color5: ColorInfo = { name: '紫禁城紫', hex: '#9B59B6', rgb: { r: 155, g: 89, b: 182 } };
const color6: ColorInfo = { name: '金箔黄', hex: '#F1C40F', rgb: { r: 241, g: 196, b: 15 } };
const color7: ColorInfo = { name: '朱砂红', hex: '#E74C3C', rgb: { r: 231, g: 76, b: 60 } };
const color8: ColorInfo = { name: '青花蓝', hex: '#3498DB', rgb: { r: 52, g: 152, b: 219 } };
const color9: ColorInfo = { name: '墨黑', hex: '#2C3E50', rgb: { r: 44, g: 62, b: 80 } };
const color10: ColorInfo = { name: '象牙白', hex: '#F8F9FA', rgb: { r: 248, g: 249, b: 250 } };
const color11: ColorInfo = { name: '青铜绿', hex: '#16A085', rgb: { r: 22, g: 160, b: 133 } };
const color12: ColorInfo = { name: '胭脂红', hex: '#C0392B', rgb: { r: 192, g: 57, b: 43 } };

export const PALACE_COLORS: ColorInfo[] = [
  color1, color2, color3, color4, color5, color6,
  color7, color8, color9, color10, color11, color12
];

/**
 * 根据RGB值查找最接近的颜色名称
 */
export function findClosestColor(r: number, g: number, b: number): ColorInfo {
  let minDistance = Infinity;
  let closestColor = PALACE_COLORS[0];

  for (let i = 0; i < PALACE_COLORS.length; i++) {
    const color = PALACE_COLORS[i];
    const distance = Math.sqrt(
      Math.pow(r - color.rgb.r, 2) +
      Math.pow(g - color.rgb.g, 2) +
      Math.pow(b - color.rgb.b, 2)
    );
    if (distance < minDistance) {
      minDistance = distance;
      closestColor = color;
    }
  }

  return closestColor;
}

/**
 * RGB转Hex
 */
export function rgbToHex(r: number, g: number, b: number): string {
  const toHex = (n: number): string => {
    const hex = Math.round(n).toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  };
  return '#' + toHex(r) + toHex(g) + toHex(b);
}
