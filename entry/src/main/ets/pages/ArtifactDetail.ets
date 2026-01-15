import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

interface ArtifactInfo {
  detailInfo: string;
  period: string;
  origin: string;
  dimensions: string;
  material: string;
  currentLocation: string;
  significance: string;
  history: string;
  relatedArtifacts: string[];
}

@Entry
@Component
struct ArtifactDetail {
  @State artifactName: string = '';
  @State artifactDescription: string = '';
  @State artifactImage: string = '';
  @State artifactId: number = 0;
  @State era: string = '';
  @State region: string = '';
  @State material: string = '';
  @State theme: string = '';
  @State tags: string[] = [];
  @State detailInfo: string = '';
  @State period: string = '';
  @State origin: string = '';
  @State dimensions: string = '';
  @State materialDetail: string = '';
  @State currentLocation: string = '';
  @State significance: string = '';
  @State history: string = '';
  @State relatedArtifacts: string[] = [];
  @State preferencesStore: preferences.Preferences | null = null;

  async aboutToAppear() {
    // 记录浏览
    await this.recordView();
    // 获取传递的参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params) {
      this.artifactId = params['id'] as number || 0;
      this.artifactName = params['name'] as string || '';
      this.artifactDescription = params['description'] as string || '';
      this.artifactImage = params['image'] as string || '';
      this.era = params['era'] as string || '';
      this.region = params['region'] as string || '';
      this.material = params['material'] as string || '';
      this.theme = params['theme'] as string || '';
      this.tags = params['tags'] as string[] || [];
    }
    // 获取文物详细信息
    this.searchArtifactInfo(this.artifactName);
  }

  async recordView() {
    try {
      const context = getContext(this) as Context;
      this.preferencesStore = await preferences.getPreferences(context, 'user_data');
      if (this.preferencesStore) {
        const viewedArtifacts = await this.preferencesStore.get('viewedArtifacts', 0) as number;
        const viewedList = await this.preferencesStore.get('viewedArtifactList', '[]') as string;
        let list: number[] = JSON.parse(viewedList);
        
        if (!list.includes(this.artifactId)) {
          list.push(this.artifactId);
          await this.preferencesStore.put('viewedArtifacts', viewedArtifacts + 1);
          await this.preferencesStore.put('viewedArtifactList', JSON.stringify(list));
          await this.preferencesStore.flush();
        }
      }
    } catch (error) {
      console.error('记录浏览失败:', error);
    }
  }

  searchArtifactInfo(name: string) {
    // 根据文物名称设置详细信息
    const artifactInfoMap: Record<string, ArtifactInfo> = {
      '清明上河图': {
        detailInfo: '《清明上河图》是北宋画家张择端创作的一幅绢本设色长卷，宽24.8厘米，长528.7厘米。该画作描绘了北宋都城汴京（今河南开封）的城市面貌和当时社会各阶层人民的生活状况，是研究北宋城市社会生活的重要史料。',
        period: '北宋（960-1127年）',
        origin: '中国·河南开封',
        dimensions: '24.8cm × 528.7cm',
        material: '绢本设色',
        currentLocation: '北京故宫博物院',
        significance: '《清明上河图》是中国十大传世名画之一，被誉为"中华第一神品"，是研究中国古代城市生活、建筑、交通、商业、服饰等的重要图像资料。',
        history: '该画作创作于北宋徽宗时期，后历经战乱，多次易主。现藏于北京故宫博物院，是故宫的镇馆之宝之一。',
        relatedArtifacts: ['千里江山图', '韩熙载夜宴图', '富春山居图']
      },
      '罗塞塔石碑': {
        detailInfo: '罗塞塔石碑（Rosetta Stone）是一块制作于公元前196年的花岗闪长岩石碑，刻有古埃及国王托勒密五世登基的诏书。石碑上用三种文字刻写了同样的内容：古埃及象形文字、古埃及草书和古希腊文。',
        period: '托勒密王朝（公元前196年）',
        origin: '古埃及',
        dimensions: '114.4cm × 72.3cm × 27.9cm',
        material: '花岗闪长岩',
        currentLocation: '大英博物馆',
        significance: '罗塞塔石碑是解密古埃及象形文字的关键，让现代学者能够理解古埃及文字系统，对埃及学研究具有里程碑意义。',
        history: '1799年，拿破仑军队在埃及罗塞塔镇附近发现此石碑。1801年，英军击败法军后，石碑被运往英国，现藏于大英博物馆。',
        relatedArtifacts: ['纳尔迈调色板', '图坦卡蒙黄金面具', '拉美西斯二世雕像']
      },
      '蒙娜丽莎': {
        detailInfo: '《蒙娜丽莎》（Mona Lisa）是意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，创作于1503-1519年。画中人物是佛罗伦萨商人弗朗切斯科·德尔·焦孔多的妻子丽莎·焦孔多。',
        period: '文艺复兴时期（1503-1519年）',
        origin: '意大利·佛罗伦萨',
        dimensions: '77cm × 53cm',
        material: '木板油画',
        currentLocation: '法国·卢浮宫',
        significance: '《蒙娜丽莎》是世界上最著名的油画作品之一，以其神秘的微笑而闻名于世。达·芬奇运用了"晕涂法"（sfumato）技术，创造了柔和朦胧的效果。',
        history: '该画作最初属于法国王室收藏，法国大革命后被移至卢浮宫。1911年曾被盗窃，两年后找回。现为卢浮宫的镇馆之宝。',
        relatedArtifacts: ['最后的晚餐', '维特鲁威人', '岩间圣母']
      },
      '兵马俑': {
        detailInfo: '兵马俑是秦始皇陵的陪葬坑中的陶俑，发现于1974年。兵马俑规模宏大，造型逼真，是中国古代雕塑艺术的杰作。目前已发现三个陪葬坑，共出土陶俑、陶马约8000件。',
        period: '秦代（公元前221-207年）',
        origin: '中国·陕西临潼',
        dimensions: '平均高度约1.8米',
        material: '陶土',
        currentLocation: '中国·陕西秦始皇兵马俑博物馆',
        significance: '兵马俑被誉为"世界第八大奇迹"，是研究秦代军事、艺术、科技的重要实物资料，展现了秦代高超的制陶工艺和雕塑艺术。',
        history: '1974年3月，当地农民在打井时发现了兵马俑。经过考古发掘，发现了三个大型陪葬坑。1987年，秦始皇陵及兵马俑坑被列入世界文化遗产。',
        relatedArtifacts: ['青铜车马', '铜剑', '秦简']
      },
      '图坦卡蒙黄金面具': {
        detailInfo: '图坦卡蒙黄金面具是古埃及法老图坦卡蒙的葬礼面具，制作于公元前1323年。面具由纯金制成，重达11公斤，镶嵌有青金石、红玉髓、彩色玻璃等宝石，展现了古埃及精湛的金属加工工艺和宗教信仰。面具完美地再现了图坦卡蒙的容貌，是古埃及艺术的代表作。',
        period: '古埃及新王国时期（公元前1323年）',
        origin: '古埃及·底比斯',
        dimensions: '高54cm，宽39.3cm',
        material: '黄金、青金石、红玉髓、彩色玻璃',
        currentLocation: '埃及·开罗埃及博物馆',
        significance: '图坦卡蒙黄金面具是古埃及艺术最著名的作品之一，代表了古埃及金属工艺的最高水平，是研究古埃及法老文化和葬礼习俗的重要文物。',
        history: '1922年，英国考古学家霍华德·卡特在帝王谷发现了图坦卡蒙的陵墓，黄金面具是其中最重要的发现之一。面具保存完好，是古埃及文物中最珍贵的艺术品。',
        relatedArtifacts: ['图坦卡蒙木乃伊', '图坦卡蒙金棺', '拉美西斯二世雕像']
      },
      '维伦多夫的维纳斯': {
        detailInfo: '维伦多夫的维纳斯（Venus of Willendorf）是旧石器时代的小型女性雕像，制作于约公元前25000-20000年。雕像高11厘米，由石灰石雕刻而成，是已知最早的人类艺术表现之一。雕像突出了女性的生殖特征，可能用于生殖崇拜或宗教仪式。',
        period: '旧石器时代晚期（约公元前25000-20000年）',
        origin: '奥地利·维伦多夫',
        dimensions: '高11cm',
        material: '石灰石',
        currentLocation: '奥地利·维也纳自然历史博物馆',
        significance: '维伦多夫的维纳斯是人类艺术史上的重要里程碑，展现了旧石器时代人类的艺术创作能力和精神世界，是研究史前艺术和人类文明起源的重要文物。',
        history: '1908年，考古学家在奥地利维伦多夫附近发现了这尊雕像。它是旧石器时代最著名的艺术品之一，现藏于维也纳自然历史博物馆。',
        relatedArtifacts: ['拉斯科洞窟壁画', '阿尔塔米拉洞窟壁画', '肖维岩洞壁画']
      },
      '大卫像': {
        detailInfo: '《大卫像》（David）是意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑，创作于1501-1504年。雕像高5.17米，描绘了《圣经》中大卫王准备与巨人歌利亚战斗的场景。大卫被塑造成一个健美的青年，展现了文艺复兴时期对人体美的追求。',
        period: '文艺复兴时期（1501-1504年）',
        origin: '意大利·佛罗伦萨',
        dimensions: '高517cm',
        material: '大理石',
        currentLocation: '意大利·佛罗伦萨学院美术馆',
        significance: '《大卫像》是文艺复兴雕塑艺术的巅峰之作，展现了米开朗基罗卓越的雕塑技艺和对人体解剖的深刻理解，是文艺复兴艺术的代表作。',
        history: '雕像最初放置在佛罗伦萨市政厅前，1873年被移至佛罗伦萨学院美术馆保护。原址现有一尊复制品。',
        relatedArtifacts: ['摩西像', '圣母怜子', '奴隶像']
      },
      '星夜': {
        detailInfo: '《星夜》（The Starry Night）是荷兰后印象派画家文森特·梵高创作的油画，创作于1889年。画作描绘了夜晚的星空和村庄，展现了梵高独特的笔触和色彩运用。画中的漩涡状星空和明亮的星星，体现了梵高对自然和宇宙的深刻感受。',
        period: '后印象派时期（1889年）',
        origin: '法国·圣雷米',
        dimensions: '73.7cm × 92.1cm',
        material: '布面油画',
        currentLocation: '美国·纽约现代艺术博物馆',
        significance: '《星夜》是梵高最具代表性的作品之一，以其独特的艺术风格和强烈的情感表达而闻名，是后印象派艺术的经典之作。',
        history: '该画作创作于梵高在圣雷米精神病院期间。1941年，画作被纽约现代艺术博物馆收藏，现为该馆的镇馆之宝之一。',
        relatedArtifacts: ['向日葵', '自画像', '麦田群鸦']
      },
      '向日葵': {
        detailInfo: '《向日葵》（Sunflowers）是荷兰后印象派画家文森特·梵高创作的系列油画作品，创作于1888-1889年。梵高共创作了11幅向日葵作品，以明亮的黄色为主调，展现了向日葵的生命力和自然美。这些作品体现了梵高对生命的热爱和对艺术的执着追求。',
        period: '后印象派时期（1888-1889年）',
        origin: '法国·阿尔勒',
        dimensions: '92cm × 73cm（其中一幅）',
        material: '布面油画',
        currentLocation: '多个博物馆（伦敦国家美术馆、阿姆斯特丹梵高博物馆等）',
        significance: '《向日葵》系列是梵高最著名的作品之一，以其鲜艳的色彩和强烈的表现力而闻名，是印象派艺术的经典之作，展现了梵高独特的艺术风格。',
        history: '梵高在阿尔勒期间创作了这些向日葵作品，希望用它们装饰高更的房间。这些作品现分散收藏于世界各地的博物馆。',
        relatedArtifacts: ['星夜', '自画像', '阿尔勒的卧室']
      },
      '思想者': {
        detailInfo: '《思想者》（The Thinker）是法国雕塑家奥古斯特·罗丹创作的青铜雕塑，创作于1880年。雕像高71.5厘米，表现的是一个坐在岩石上沉思的裸体男性。雕像展现了人类思考时的专注和深刻，象征着人类对知识的追求和对存在的思考。',
        period: '19世纪末（1880年）',
        origin: '法国·巴黎',
        dimensions: '高71.5cm（原始版本）',
        material: '青铜',
        currentLocation: '法国·罗丹博物馆（多个版本）',
        significance: '《思想者》是罗丹最著名的作品之一，是现代雕塑艺术的经典之作，象征着人类对知识的追求和对存在的思考，具有深刻的哲学意义。',
        history: '该作品最初是为《地狱之门》创作的，后来成为独立作品。罗丹制作了多个版本，现藏于世界各地的博物馆，包括巴黎罗丹博物馆、费城艺术博物馆等。',
        relatedArtifacts: ['吻', '加莱义民', '巴尔扎克像']
      },
      '睡莲': {
        detailInfo: '《睡莲》（Water Lilies）是法国印象派画家克劳德·莫奈创作的系列油画作品，创作于1899-1926年。莫奈共创作了250多幅睡莲作品，以他在吉维尼花园中的睡莲池为题材，展现了莫奈对光影变化的敏锐观察和对自然美的深刻感受。',
        period: '印象派时期（1899-1926年）',
        origin: '法国·吉维尼',
        dimensions: '尺寸不一（最大约200cm × 600cm）',
        material: '布面油画',
        currentLocation: '多个博物馆（巴黎橘园美术馆、纽约现代艺术博物馆等）',
        significance: '《睡莲》系列是印象派艺术的巅峰之作，展现了莫奈对光影和色彩的极致追求，是研究印象派艺术的重要作品，被誉为"印象派的《西斯廷教堂》"。',
        history: '莫奈在吉维尼建造了睡莲池，并以此为题材创作了大量作品。这些作品现分散收藏于世界各地的博物馆，其中巴黎橘园美术馆收藏了最著名的《睡莲》系列。',
        relatedArtifacts: ['日出·印象', '干草堆', '鲁昂大教堂']
      },
      '最后的晚餐': {
        detailInfo: '《最后的晚餐》（The Last Supper）是意大利文艺复兴时期画家列奥纳多·达·芬奇创作的壁画，创作于1495-1498年。画作描绘了耶稣与十二门徒共进最后一餐的场景，展现了达·芬奇卓越的构图技巧和对人物心理的深刻刻画。',
        period: '文艺复兴时期（1495-1498年）',
        origin: '意大利·米兰',
        dimensions: '460cm × 880cm',
        material: '壁画（蛋彩画）',
        currentLocation: '意大利·米兰圣玛利亚感恩教堂',
        significance: '《最后的晚餐》是文艺复兴艺术的杰作，以其完美的构图、深刻的心理刻画和精湛的技法而闻名，是研究文艺复兴艺术的重要作品。',
        history: '画作绘制在米兰圣玛利亚感恩教堂的餐厅墙壁上。由于技法问题，画作在创作后不久就开始损坏。经过多次修复，现仍保存于原址。',
        relatedArtifacts: ['蒙娜丽莎', '岩间圣母', '维特鲁威人']
      },
      '自由引导人民': {
        detailInfo: '《自由引导人民》（Liberty Leading the People）是法国浪漫主义画家欧仁·德拉克洛瓦创作的油画，创作于1830年。画作描绘了1830年法国七月革命的场景，展现了人民为自由而战的英勇精神。画中的自由女神象征着自由、平等、博爱的理念。',
        period: '浪漫主义时期（1830年）',
        origin: '法国·巴黎',
        dimensions: '260cm × 325cm',
        material: '布面油画',
        currentLocation: '法国·卢浮宫',
        significance: '《自由引导人民》是浪漫主义艺术的代表作，以其强烈的动感、情感表达和革命主题而闻名，是法国艺术史上的重要作品。',
        history: '画作创作于1830年七月革命后，最初被法国政府购买，后因政治原因被撤回。1874年，画作被卢浮宫收藏，现为该馆的重要藏品。',
        relatedArtifacts: ['希阿岛的屠杀', '萨达纳帕尔之死', '但丁之舟']
      },
      '富春山居图': {
        detailInfo: '《富春山居图》是元代画家黄公望创作的山水画长卷，创作于1350年。画作全长636.9厘米，高33厘米，描绘了富春江两岸的山水景色。画作以水墨为主，展现了黄公望深厚的山水画功底和对自然山水的深刻理解。',
        period: '元代（1350年）',
        origin: '中国·浙江富春江',
        dimensions: '33cm × 636.9cm',
        material: '纸本水墨',
        currentLocation: '分藏于浙江省博物馆（剩山图）和台北故宫博物院（无用师卷）',
        significance: '《富春山居图》是中国古代山水画的巅峰之作，被誉为"画中之兰亭"，是研究元代山水画的重要作品，展现了中国传统山水画的最高水平。',
        history: '画作在清代被分为两段，前段《剩山图》现藏于浙江省博物馆，后段《无用师卷》现藏于台北故宫博物院。2011年，两段在台北故宫博物院合璧展出。',
        relatedArtifacts: ['清明上河图', '千里江山图', '韩熙载夜宴图']
      },
      '掷铁饼者': {
        detailInfo: '《掷铁饼者》（Discobolus）是古希腊雕塑家米隆创作的大理石雕塑，创作于约公元前450年。雕像描绘了运动员投掷铁饼的瞬间，展现了古希腊对人体美的追求和对运动精神的赞美。雕像以完美的比例和动态的姿势而闻名。',
        period: '古希腊古典时期（约公元前450年）',
        origin: '古希腊',
        dimensions: '高约152cm',
        material: '大理石（原作已失，现存为罗马复制品）',
        currentLocation: '多个博物馆（意大利罗马国家博物馆、大英博物馆等）',
        significance: '《掷铁饼者》是古典雕塑艺术的代表作，展现了古希腊对人体解剖和运动姿态的深刻理解，是研究古希腊艺术的重要作品。',
        history: '原作已失传，现存的是古罗马时期的复制品。这些复制品现收藏于世界各地的博物馆，包括罗马国家博物馆、大英博物馆等。',
        relatedArtifacts: ['断臂的维纳斯', '拉奥孔群雕', '胜利女神像']
      },
      '断臂的维纳斯': {
        detailInfo: '《米洛的维纳斯》（Venus de Milo）是古希腊雕塑作品，创作于约公元前130-100年。雕像高2.04米，由两块大理石拼接而成，表现的是希腊神话中的爱神阿佛洛狄忒（罗马神话中的维纳斯）。雕像以其完美的比例和优雅的姿态而闻名，是古典美的象征。',
        period: '古希腊（公元前130-100年）',
        origin: '希腊·米洛斯岛',
        dimensions: '高204cm',
        material: '大理石',
        currentLocation: '法国·卢浮宫',
        significance: '《米洛的维纳斯》是古希腊雕塑艺术的代表作，以其完美的比例和优雅的姿态而闻名，是古典美的象征，被誉为"美的象征"。',
        history: '1820年，雕像在希腊米洛斯岛被发现，后被法国购买并运往巴黎。现藏于卢浮宫，是卢浮宫的三大镇馆之宝之一，与《蒙娜丽莎》和《胜利女神像》齐名。',
        relatedArtifacts: ['胜利女神像', '拉奥孔群雕', '掷铁饼者']
      },
      '夜巡': {
        detailInfo: '《夜巡》（The Night Watch）是荷兰巴洛克画家伦勃朗创作的油画，创作于1642年。画作描绘了阿姆斯特丹民兵连队的群像，展现了伦勃朗独特的光影效果和构图技巧。画作以其戏剧性的光影和生动的人物刻画而闻名。',
        period: '巴洛克时期（1642年）',
        origin: '荷兰·阿姆斯特丹',
        dimensions: '363cm × 437cm',
        material: '布面油画',
        currentLocation: '荷兰·阿姆斯特丹国家博物馆',
        significance: '《夜巡》是伦勃朗最具代表性的作品之一，以其独特的光影效果和构图而闻名，是巴洛克艺术的杰作，展现了伦勃朗卓越的绘画技艺。',
        history: '画作最初名为《弗朗斯·班宁·科克上尉的连队》，后因画面较暗被称为《夜巡》。画作现藏于阿姆斯特丹国家博物馆，是该馆的镇馆之宝。',
        relatedArtifacts: ['犹太新娘', '自画像', '解剖学课']
      },
      '记忆的永恒': {
        detailInfo: '《记忆的永恒》（The Persistence of Memory）是西班牙超现实主义画家萨尔瓦多·达利创作的油画，创作于1931年。画作描绘了融化的时钟和荒凉的风景，展现了达利超现实的想象力和精湛的技法。画作以其独特的视觉语言和深刻的象征意义而闻名。',
        period: '超现实主义时期（1931年）',
        origin: '西班牙',
        dimensions: '24cm × 33cm',
        material: '布面油画',
        currentLocation: '美国·纽约现代艺术博物馆',
        significance: '《记忆的永恒》是超现实主义艺术的代表作，以其超现实的想象力和精湛的技法而闻名，是研究超现实主义艺术的重要作品，展现了达利独特的艺术风格。',
        history: '画作创作于1931年，是达利最著名的作品之一。1934年，画作被纽约现代艺术博物馆收藏，现为该馆的重要藏品。',
        relatedArtifacts: ['内战的预兆', '十字架上的基督', '原子的丽达']
      },
      '呐喊': {
        detailInfo: '《呐喊》（The Scream）是挪威表现主义画家爱德华·蒙克创作的油画，创作于1893年。画作描绘了一个在桥上呐喊的人物，展现了蒙克强烈的情感表达和独特的色彩运用。画作以其强烈的视觉冲击力和深刻的心理刻画而闻名。',
        period: '表现主义时期（1893年）',
        origin: '挪威',
        dimensions: '91cm × 73.5cm',
        material: '纸板油画',
        currentLocation: '挪威·奥斯陆国家美术馆',
        significance: '《呐喊》是表现主义艺术的代表作，以其强烈的情感表达和独特的色彩运用而闻名，是研究表现主义艺术的重要作品，展现了蒙克对现代人焦虑和孤独的深刻洞察。',
        history: '蒙克共创作了四个版本的《呐喊》，其中1893年的版本现藏于奥斯陆国家美术馆。1994年和2004年，画作曾两次被盗，后均被找回。',
        relatedArtifacts: ['青春期', '病中的孩子', '生命之舞']
      },
      '格尔尼卡': {
        detailInfo: '《格尔尼卡》（Guernica）是西班牙立体主义画家巴勃罗·毕加索创作的油画，创作于1937年。画作描绘了西班牙内战期间格尔尼卡镇被轰炸的场景，展现了毕加索强烈的反战主题和独特的艺术风格。画作以其巨大的尺度和强烈的视觉冲击力而闻名。',
        period: '立体主义时期（1937年）',
        origin: '西班牙',
        dimensions: '349.3cm × 776.6cm',
        material: '布面油画',
        currentLocation: '西班牙·马德里索菲亚王后国家艺术中心博物馆',
        significance: '《格尔尼卡》是20世纪最重要的反战艺术作品之一，以其强烈的反战主题和独特的艺术风格而闻名，是研究现代艺术和反战艺术的重要作品，展现了艺术的社会责任。',
        history: '画作为1937年巴黎世界博览会西班牙馆而创作，后长期借展于纽约现代艺术博物馆。1981年，画作被运回西班牙，现藏于马德里索菲亚王后国家艺术中心博物馆。',
        relatedArtifacts: ['亚威农少女', '三个音乐家', '镜前的少女']
      }
    };

    const defaultInfo: ArtifactInfo = {
      detailInfo: this.artifactDescription,
      period: '时期待补充',
      origin: '来源待补充',
      dimensions: '尺寸待补充',
      material: this.material || '材质待补充',
      currentLocation: '现藏地待补充',
      significance: '历史意义待补充',
      history: '历史背景待补充',
      relatedArtifacts: ['相关文物1', '相关文物2', '相关文物3']
    };
    const info: ArtifactInfo = artifactInfoMap[name] || defaultInfo;

    this.detailInfo = info.detailInfo;
    this.period = info.period;
    this.origin = info.origin;
    this.dimensions = info.dimensions;
    this.materialDetail = info.material;
    this.currentLocation = info.currentLocation;
    this.significance = info.significance;
    this.history = info.history;
    this.relatedArtifacts = info.relatedArtifacts;
  }

  setDefaultInfo() {
    this.detailInfo = this.artifactDescription;
    this.period = '时期待补充';
    this.origin = '来源待补充';
    this.dimensions = '尺寸待补充';
    this.materialDetail = this.material || '材质待补充';
    this.currentLocation = '现藏地待补充';
    this.significance = '历史意义待补充';
    this.history = '历史背景待补充';
    this.relatedArtifacts = ['相关文物1', '相关文物2', '相关文物3'];
  }

  build() {
    Scroll() {
      Column() {
        // 导航栏
        this.NavBar()

        // 文物图片
        this.ArtifactImage()

        // 基本信息
        this.BasicInfo()

        // 详细介绍
        this.DetailSection()

        // 历史意义
        this.SignificanceSection()

        // 历史背景
        this.HistorySection()

        // 相关文物
        this.RelatedArtifactsSection()
      }
      .width('100%')
      .backgroundColor($r('app.color.app_background'))
    }
  }

  @Builder
  NavBar() {
    Row() {
      Row() {
        Image($r('app.media.startIcon'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        Text('返回')
          .fontSize(16)
          .fontColor($r('app.color.text_inverse'))
      }
      .onClick(() => {
        router.back() as void
      })
      .padding({ left: 8, right: 12, top: 8, bottom: 8 })
      .borderRadius(8)

      Text('文物详情')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_inverse'))
        .margin({ left: 16 })

      Blank()
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.primary_color'))
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color('#3949ab')
      Text('正在加载文物信息...')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 16 })
    }
    .width('100%')
    .height(400)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  ArtifactImage() {
    Stack() {
      Image(this.getArtifactImage(this.artifactImage))
        .width('100%')
        .height(300)
        .objectFit(ImageFit.Cover)
        .alt(this.artifactName)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.shadow_color'))
        .opacity(0.5)

      Column() {
        Text(this.artifactName)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_inverse'))
          .textAlign(TextAlign.Center)
          .textShadow({ radius: 8, color: '#000000', offsetX: 2, offsetY: 2 })
          .margin({ bottom: 12 })

        Row() {
          ForEach(this.tags, (tag: string) => {
            Text(tag)
              .fontSize(12)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor($r('app.color.text_inverse'))
              .opacity(0.3)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(12)
              .margin({ right: 6 })
          })
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 20, right: 20 })
    }
    .width('100%')
    .height(300)
  }

  @Builder
  BasicInfo() {
    Column() {
      Row() {
        Column() {
          Text('时期')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.period)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('来源')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.origin)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 16 })

      Row() {
        Column() {
          Text('尺寸')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.dimensions)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('材质')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.materialDetail)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 16 })

      Row() {
        Column() {
          Text('现藏地')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.currentLocation)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#ffffff')
    .margin({ top: 20, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  DetailSection() {
    Column() {
      Text('详细介绍')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Text(this.detailInfo)
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(24)
        .textAlign(TextAlign.JUSTIFY)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#ffffff')
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  SignificanceSection() {
    Column() {
      Text('历史意义')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Text(this.significance)
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(24)
        .textAlign(TextAlign.JUSTIFY)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#ffffff')
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  HistorySection() {
    Column() {
      Text('历史背景')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Text(this.history)
        .fontSize(15)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(24)
        .textAlign(TextAlign.JUSTIFY)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#ffffff')
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  RelatedArtifactsSection() {
    Column() {
      Text('相关文物')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Column() {
        ForEach(this.relatedArtifacts, (item: string, index: number) => {
          Column() {
            Row() {
              Text(`${index + 1}`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_inverse'))
                .backgroundColor('#3949ab')
                .width(24)
                .height(24)
                .textAlign(TextAlign.Center)
                .borderRadius(12)
                .margin({ right: 12 })

              Text(item)
                .fontSize(15)
                .fontColor($r('app.color.text_primary'))
                .layoutWeight(1)
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })

            if (index < this.relatedArtifacts.length - 1) {
              Divider()
                .color('#e0e0e0')
                .strokeWidth(1)
                .margin({ left: 36 })
            }
          }
          .width('100%')
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#ffffff')
    .margin({ top: 16, left: 16, right: 16, bottom: 40 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  getArtifactImage(imageName: string): Resource | string {
    // 使用本地图片资源，与images文件夹中的图片对应
    const imageMap: Record<string, Resource> = {
      '清明上河图': $rawfile('清明上河图.png'),
      '罗塞塔石碑': $rawfile('罗塞塔石碑.png'),
      '蒙娜丽莎': $rawfile('蒙娜丽莎.png'),
      '兵马俑': $rawfile('兵马俑.png'),
      '图坦卡蒙黄金面具': $rawfile('图坦卡蒙黄金面具.png'),
      '维伦多夫的维纳斯': $rawfile('维伦多夫的维纳斯.png'),
      '大卫像': $rawfile('大卫像.webp'),
      '星夜': $rawfile('星夜.webp'),
      '向日葵': $rawfile('向日葵.jpg'),
      '思想者': $rawfile('思想者.webp'),
      '睡莲': $rawfile('睡莲.webp'),
      '最后的晚餐': $rawfile('最后的晚餐.webp'),
      '自由引导人民': $rawfile('自由引导人民.png'),
      '富春山居图': $rawfile('富春山居图.webp'),
      '掷铁饼者': $rawfile('掷铁饼者.jpg'),
      '断臂的维纳斯': $rawfile('断臂的维纳斯.jpg'),
      '夜巡': $rawfile('夜巡.webp'),
      '记忆的永恒': $rawfile('记忆的永恒.webp'),
      '呐喊': $rawfile('呐喊.webp'),
      '格尔尼卡': $rawfile('格尔尼卡.webp')
    };
    return imageMap[imageName] || $rawfile('兵马俑.png');
  }
}
