import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

interface ArchitectInfo {
  name: string;
  period: string;
  nationality: string;
  description: string;
}

interface ArchitectureInfo {
  style: string;
  architect: ArchitectInfo;
  designConcept: string;
  buildingImages: string[];
  features: string[];
}

interface MuseumInfo {
  detailInfo: string;
  location: string;
  established: string;
  collections: string;
  highlights: string[];
  website: string;
  openingHours: string;
  architecture?: ArchitectureInfo;
}

@Entry
@Component
struct MuseumDetail {
  @State museumName: string = '';
  @State museumDescription: string = '';
  @State museumImage: string = '';
  @State museumId: number = 0;
  @State detailInfo: string = '';
  @State location: string = '';
  @State established: string = '';
  @State collections: string = '';
  @State highlights: string[] = [];
  @State website: string = '';
  @State openingHours: string = '';
  @State architecture: ArchitectureInfo | null = null;
  @State preferencesStore: preferences.Preferences | null = null;

  async aboutToAppear() {
    // 获取传递的参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params) {
      this.museumId = params['id'] as number || 0;
      this.museumName = params['name'] as string || '';
      this.museumDescription = params['description'] as string || '';
      this.museumImage = params['image'] as string || '';
    }
    // 获取博物馆详细信息
    this.searchMuseumInfo(this.museumName);
    // 记录浏览
    await this.recordView();
  }

  searchMuseumInfo(name: string) {
    // 根据博物馆名称设置详细信息
    const museumInfoMap: Record<string, MuseumInfo> = {
      '故宫博物院': {
        detailInfo: '北京故宫博物院，旧称紫禁城，位于北京中轴线的中心，是中国明清两朝的皇家宫殿。故宫于明成祖永乐四年（1406年）开始建设，以南京故宫为蓝本营建，到永乐十八年（1420年）建成，成为明清两朝二十四位皇帝的皇宫。',
        location: '中国·北京市东城区景山前街4号',
        established: '1925年10月10日',
        collections: '超过180万件文物',
        highlights: ['太和殿', '乾清宫', '珍宝馆', '钟表馆', '书画馆'],
        website: 'https://www.dpm.org.cn',
        openingHours: '08:30-17:00（旺季4月1日-10月31日），08:30-16:30（淡季11月1日-次年3月31日），周一闭馆',
        architecture: {
          style: '明清宫殿建筑',
          architect: {
            name: '蒯祥等',
            period: '明代',
            nationality: '中国',
            description: '故宫由明代著名建筑师蒯祥等人设计建造，体现了中国传统宫殿建筑的精华，采用中轴线对称布局，体现了"天人合一"的哲学思想。'
          },
          designConcept: '故宫建筑群严格按照《周礼·考工记》中"前朝后市，左祖右社"的帝都营建原则建造，体现了中国古代"天人合一"的哲学思想和严格的等级制度。整个建筑群以中轴线为中心，左右对称，层次分明，体现了中国古代建筑艺术的最高成就。',
          buildingImages: ['故宫', '故宫'],
          features: ['中轴线对称布局', '黄琉璃瓦屋顶', '红墙金瓦', '九千九百九十九间半房屋', '三大殿建筑群']
        }
      },
      '大英博物馆': {
        detailInfo: '大英博物馆（British Museum），又名不列颠博物馆，位于英国伦敦新牛津大街北面的罗素广场，成立于1753年，1759年1月15日起正式对公众开放，是世界上历史最悠久、规模最宏伟的综合性博物馆，也是世界上规模最大、最著名的世界四大博物馆之一。',
        location: '英国·伦敦新牛津大街北面的罗素广场',
        established: '1753年',
        collections: '超过800万件藏品',
        highlights: ['罗塞塔石碑', '帕特农神庙石雕', '埃及木乃伊', '中国瓷器', '古希腊雕塑'],
        website: 'https://www.britishmuseum.org',
        openingHours: '10:00-17:00，周五延长至20:30，周一至周日开放',
        architecture: {
          style: '新古典主义',
          architect: {
            name: '罗伯特·斯默克',
            period: '19世纪',
            nationality: '英国',
            description: '罗伯特·斯默克是19世纪英国著名建筑师，设计了新古典主义风格的大英博物馆主建筑，体现了古希腊和古罗马建筑的影响。'
          },
          designConcept: '大英博物馆的建筑采用新古典主义风格，体现了对古希腊和古罗马建筑的致敬。建筑外观庄严肃穆，内部空间宽敞明亮，特别是由诺曼·福斯特设计的大中庭，采用玻璃穹顶，创造了欧洲最大的有顶广场，体现了传统与现代的完美结合。',
          buildingImages: ['大英博物馆', '大英博物馆'],
          features: ['新古典主义柱廊', '大中庭玻璃穹顶', '希腊式门廊', '对称式布局', '古典装饰元素']
        }
      },
      '卢浮宫': {
        detailInfo: '卢浮宫（法语：Musée du Louvre），位于法国巴黎市中心的塞纳河北岸，位居世界四大博物馆之首。始建于1204年，原是法国的王宫，居住过50位法国国王和王后，是法国文艺复兴时期最珍贵的建筑物之一，以收藏丰富的古典绘画和雕刻而闻名于世。',
        location: '法国·巴黎市中心的塞纳河北岸',
        established: '1793年8月10日',
        collections: '超过40万件艺术品',
        highlights: ['蒙娜丽莎', '维纳斯雕像', '胜利女神像', '汉谟拉比法典', '拿破仑加冕'],
        website: 'https://www.louvre.fr',
        openingHours: '09:00-18:00，周二闭馆，周三和周五延长至21:45',
        architecture: {
          style: '文艺复兴与巴洛克混合风格',
          architect: {
            name: '皮埃尔·莱斯科、克劳德·佩罗等',
            period: '16-17世纪',
            nationality: '法国',
            description: '卢浮宫经历了多个时期的扩建，由多位著名建筑师参与设计，包括皮埃尔·莱斯科、克劳德·佩罗等，融合了文艺复兴、巴洛克等多种建筑风格。'
          },
          designConcept: '卢浮宫建筑群体现了法国建筑艺术的演变历程，从最初的防御性城堡到文艺复兴时期的宫殿，再到现代博物馆。贝聿铭设计的玻璃金字塔入口，将现代建筑元素与传统建筑完美融合，成为卢浮宫的标志性建筑。',
          buildingImages: ['卢浮宫', '卢浮宫'],
          features: ['玻璃金字塔入口', '文艺复兴庭院', '巴洛克装饰', '古典柱廊', '对称式布局']
        }
      },
      '大都会艺术博物馆': {
        detailInfo: '大都会艺术博物馆（Metropolitan Museum of Art），简称"大都会博物馆"，位于美国纽约州纽约市中央公园旁，是世界上最大的、参观人数最多的艺术博物馆之一。主建筑物面积约有8公顷，展出面积有20多公顷。',
        location: '美国·纽约市中央公园旁',
        established: '1870年',
        collections: '超过200万件艺术品',
        highlights: ['古埃及艺术', '欧洲绘画', '美国艺术', '亚洲艺术', '现代艺术'],
        website: 'https://www.metmuseum.org',
        openingHours: '10:00-17:00，周五和周六延长至21:00，周一闭馆',
        architecture: {
          style: '新古典主义',
          architect: {
            name: '理查德·莫里斯·亨特',
            period: '19-20世纪',
            nationality: '美国',
            description: '理查德·莫里斯·亨特是19世纪美国著名建筑师，设计了新古典主义风格的大都会艺术博物馆主建筑，体现了欧洲古典建筑传统在美国的传承。'
          },
          designConcept: '大都会艺术博物馆的建筑采用新古典主义风格，体现了"天圆地方"的设计理念。建筑外观庄重典雅，内部空间宽敞明亮，特别是大中庭的设计，将自然光引入室内，为艺术品展示创造了理想的环境。',
          buildingImages: ['大都会艺术博物馆', '大都会艺术博物馆'],
          features: ['新古典主义立面', '大中庭设计', '天圆地方理念', '对称式布局', '古典柱廊']
        }
      },
      '艾尔米塔什博物馆': {
        detailInfo: '艾尔米塔什博物馆（Hermitage Museum），位于俄罗斯圣彼得堡涅瓦河畔，是世界四大博物馆之一，与巴黎的卢浮宫、伦敦的大英博物馆、纽约的大都会艺术博物馆并称世界四大博物馆。该馆最早是叶卡捷琳娜二世女皇的私人宫邸。',
        location: '俄罗斯·圣彼得堡涅瓦河畔',
        established: '1764年',
        collections: '超过300万件藏品',
        highlights: ['达芬奇作品', '拉斐尔作品', '印象派绘画', '古埃及文物', '俄罗斯艺术'],
        website: 'https://www.hermitagemuseum.org',
        openingHours: '10:30-18:00，周三延长至21:00，周一闭馆'
      },
      '东京国立博物馆': {
        detailInfo: '东京国立博物馆（Tokyo National Museum），位于日本东京都台东区上野公园内，是日本历史最悠久的博物馆，也是日本最大的博物馆。该馆收藏并展示日本及亚洲地区的文物和艺术品，是了解日本文化和亚洲艺术的重要场所。',
        location: '日本·东京都台东区上野公园',
        established: '1872年',
        collections: '超过11万件藏品',
        highlights: ['日本国宝', '中国文物', '朝鲜半岛艺术', '东南亚艺术', '佛教艺术'],
        website: 'https://www.tnm.jp',
        openingHours: '09:30-17:00，周一闭馆（如遇节假日则次日闭馆）'
      },
      '中国国家博物馆': {
        detailInfo: '中国国家博物馆（National Museum of China），位于北京天安门广场东侧，与人民大会堂相对，是代表国家收藏、研究、展示、阐释能够反映中华优秀传统文化、革命文化和社会主义先进文化代表性物证的最高机构。总建筑面积近20万平方米，是世界上单体建筑面积最大的博物馆。',
        location: '中国·北京市东城区东长安街16号',
        established: '1912年7月9日',
        collections: '超过140万件文物',
        highlights: ['后母戊鼎', '四羊方尊', '人面鱼纹彩陶盆', '金缕玉衣', '明孝端皇后凤冠'],
        website: 'https://www.chnmuseum.cn',
        openingHours: '09:00-17:00，周一闭馆（法定节假日除外）'
      },
      '上海博物馆': {
        detailInfo: '上海博物馆（Shanghai Museum），位于上海市黄浦区人民大道201号，是一座大型的中国古代艺术博物馆。馆藏文物超过100万件，其中珍贵文物14万件，尤以青铜器、陶瓷、书画、玉器、印章、钱币、雕塑、家具等收藏最为丰富。',
        location: '中国·上海市黄浦区人民大道201号',
        established: '1952年',
        collections: '超过100万件文物',
        highlights: ['大克鼎', '晋侯稣钟', '淳化阁帖', '王羲之书法', '明清家具'],
        website: 'https://www.shanghaimuseum.net',
        openingHours: '09:00-17:00，周一闭馆（法定节假日除外）',
        architecture: {
          style: '现代建筑（天圆地方）',
          architect: {
            name: '邢同和',
            period: '20世纪90年代',
            nationality: '中国',
            description: '邢同和是当代中国著名建筑师，设计了体现"天圆地方"哲学思想的上海博物馆新馆，将中国传统建筑理念与现代建筑技术完美结合。'
          },
          designConcept: '上海博物馆的建筑设计灵感来源于中国古代的青铜器，体现了"天圆地方"的哲学思想。建筑外形采用圆形和方形的组合，圆形代表天，方形代表地，体现了中国古代"天人合一"的宇宙观。',
          buildingImages: ['上海博物馆', '上海博物馆'],
          features: ['天圆地方设计', '青铜器造型', '现代建筑技术', '传统文化元素', '对称式布局']
        }
      },
      '梵蒂冈博物馆': {
        detailInfo: '梵蒂冈博物馆（Vatican Museums），位于梵蒂冈城内，由罗马天主教会在数世纪以来收集的大量世界级艺术珍品组成。博物馆群包括西斯廷教堂、拉斐尔房间等多个展馆，收藏有大量文艺复兴时期的艺术品和古代文物，是世界上最著名的博物馆之一。',
        location: '梵蒂冈·梵蒂冈城',
        established: '1506年',
        collections: '超过7万件艺术品',
        highlights: ['西斯廷教堂天顶画', '拉奥孔群雕', '阿波罗·贝尔维德雷', '拉斐尔房间', '古埃及文物'],
        website: 'https://www.museivaticani.va',
        openingHours: '09:00-18:00，周五延长至22:00，周日闭馆（每月最后一个周日免费开放）'
      },
      '普拉多博物馆': {
        detailInfo: '普拉多博物馆（Museo del Prado），位于西班牙马德里，是西班牙最重要的艺术博物馆，也是世界顶级艺术博物馆之一。收藏有大量西班牙黄金时代的绘画作品，包括戈雅、委拉斯开兹、埃尔·格列柯等大师的杰作，是研究西班牙艺术的重要场所。',
        location: '西班牙·马德里普拉多大道',
        established: '1819年11月19日',
        collections: '超过8000件绘画作品',
        highlights: ['《宫娥》', '《1808年5月3日》', '《裸体的马哈》', '《三美神》', '《基督受难》'],
        website: 'https://www.museodelprado.es',
        openingHours: '10:00-20:00，周一至周六；10:00-19:00，周日和节假日'
      },
      '乌菲兹美术馆': {
        detailInfo: '乌菲兹美术馆（Galleria degli Uffizi），位于意大利佛罗伦萨，是意大利最重要的艺术博物馆之一。收藏有大量文艺复兴时期的绘画作品，包括波提切利、达·芬奇、拉斐尔、米开朗基罗等大师的作品，是文艺复兴艺术的宝库。',
        location: '意大利·佛罗伦萨乌菲兹广场',
        established: '1581年',
        collections: '超过10万件艺术品',
        highlights: ['《维纳斯的诞生》', '《春》', '《天使报喜》', '《金翅雀圣母》', '《乌尔比诺的维纳斯》'],
        website: 'https://www.uffizi.it',
        openingHours: '08:15-18:30，周二至周日；周一闭馆'
      },
      '埃及博物馆': {
        detailInfo: '埃及博物馆（Egyptian Museum），位于开罗的解放广场，是埃及国家博物馆，也是世界上收藏古埃及文物最丰富的博物馆。收藏有大量古埃及文物，包括图坦卡蒙的黄金面具、木乃伊、法老雕像等，是研究古埃及文明的重要机构。',
        location: '埃及·开罗解放广场',
        established: '1902年',
        collections: '超过12万件文物',
        highlights: ['图坦卡蒙黄金面具', '图坦卡蒙木乃伊', '拉美西斯二世雕像', '纳尔迈调色板', '古埃及木乃伊'],
        website: '暂无',
        openingHours: '09:00-17:00，周一至周日'
      },
      '古根海姆博物馆': {
        detailInfo: '古根海姆博物馆（Solomon R. Guggenheim Museum），位于纽约曼哈顿上东区，是一座现代艺术博物馆。建筑本身由弗兰克·劳埃德·赖特设计，是建筑艺术的杰作。收藏有大量20世纪和21世纪的艺术作品，包括印象派、后印象派、现代艺术和当代艺术作品。',
        location: '美国·纽约曼哈顿上东区第五大道1071号',
        established: '1937年',
        collections: '超过8000件艺术品',
        highlights: ['康定斯基作品', '毕加索作品', '蒙德里安作品', '波洛克作品', '现代雕塑'],
        website: 'https://www.guggenheim.org',
        openingHours: '10:00-17:30，周六延长至20:00，周四闭馆'
      },
      '泰特现代美术馆': {
        detailInfo: '泰特现代美术馆（Tate Modern），位于伦敦泰晤士河畔，是英国最重要的现代艺术博物馆。前身为班克赛德发电站，由瑞士建筑师赫尔佐格和德梅隆改造而成。收藏有大量20世纪和21世纪的艺术作品，是了解现代艺术发展的重要场所。',
        location: '英国·伦敦泰晤士河畔班克赛德',
        established: '2000年5月12日',
        collections: '超过7万件艺术品',
        highlights: ['《睡莲》系列', '《呐喊》', '《记忆的永恒》', '《格尔尼卡》', '现代装置艺术'],
        website: 'https://www.tate.org.uk',
        openingHours: '10:00-18:00，周一至周日'
      },
      '奥赛博物馆': {
        detailInfo: '奥赛博物馆（Musée d\'Orsay），位于巴黎塞纳河左岸，是一座19世纪艺术博物馆。前身为奥赛火车站，由建筑师维克多·拉鲁改造而成。收藏有大量印象派和后印象派作品，包括莫奈、梵高、雷诺阿、德加、高更等大师的杰作，是研究19世纪艺术的重要机构。',
        location: '法国·巴黎塞纳河左岸',
        established: '1986年12月9日',
        collections: '超过8万件艺术品',
        highlights: ['《睡莲》', '《星夜》', '《向日葵》', '《舞蹈课》', '《奥林匹亚》'],
        website: 'https://www.musee-orsay.fr',
        openingHours: '09:30-18:00，周四延长至21:45，周一闭馆'
      },
      '芝加哥艺术博物馆': {
        detailInfo: '芝加哥艺术博物馆（Art Institute of Chicago），位于芝加哥市中心，是美国重要的艺术博物馆之一。收藏有大量印象派、后印象派和现代艺术作品，以收藏《美国哥特式》、《大碗岛的星期天下午》等名作而闻名，是研究美国艺术的重要场所。',
        location: '美国·芝加哥密歇根大道111号',
        established: '1879年',
        collections: '超过30万件艺术品',
        highlights: ['《美国哥特式》', '《大碗岛的星期天下午》', '《睡莲》', '《夜巡》', '《记忆的永恒》'],
        website: 'https://www.artic.edu',
        openingHours: '11:00-17:00，周四延长至20:00，周二和周三闭馆'
      },
      '柏林国家博物馆': {
        detailInfo: '柏林国家博物馆（Staatliche Museen zu Berlin），是德国最重要的博物馆群，包括多个分馆，分布在柏林博物馆岛和城市其他地区。收藏有大量欧洲艺术和文物，以收藏古埃及、古希腊、古罗马文物而闻名，是研究欧洲文明的重要机构。',
        location: '德国·柏林博物馆岛',
        established: '1830年',
        collections: '超过500万件文物',
        highlights: ['纳芙蒂蒂半身像', '佩加蒙祭坛', '伊什塔尔门', '古希腊雕塑', '古埃及文物'],
        website: 'https://www.smb.museum',
        openingHours: '10:00-18:00，周一闭馆，各分馆时间可能不同'
      },
      '阿姆斯特丹国家博物馆': {
        detailInfo: '阿姆斯特丹国家博物馆（Rijksmuseum Amsterdam），是荷兰最重要的艺术博物馆，位于阿姆斯特丹博物馆广场。收藏有大量荷兰黄金时代的绘画作品，以收藏伦勃朗的《夜巡》等名作而闻名，是研究荷兰艺术的重要场所。',
        location: '荷兰·阿姆斯特丹博物馆广场',
        established: '1800年',
        collections: '超过100万件艺术品',
        highlights: ['《夜巡》', '《倒牛奶的女仆》', '《读信的蓝衣女子》', '《犹太新娘》', '荷兰黄金时代绘画'],
        website: 'https://www.rijksmuseum.nl',
        openingHours: '09:00-17:00，周一至周日'
      },
      '首尔国立中央博物馆': {
        detailInfo: '首尔国立中央博物馆（National Museum of Korea），是韩国最大的博物馆，位于首尔龙山区。收藏有大量韩国和亚洲的文物，以收藏高丽青瓷、朝鲜王朝文物而闻名，是研究韩国历史和文化的重要机构。',
        location: '韩国·首尔龙山区',
        established: '1945年',
        collections: '超过22万件文物',
        highlights: ['高丽青瓷', '朝鲜王朝文物', '佛教艺术品', '古代金属工艺', '韩国传统绘画'],
        website: 'https://www.museum.go.kr',
        openingHours: '10:00-18:00，周三和周六延长至21:00，周一闭馆'
      },
      '印度国家博物馆': {
        detailInfo: '印度国家博物馆（National Museum, New Delhi），是印度最重要的博物馆，位于新德里。收藏有大量印度古代文物和艺术品，以收藏印度教、佛教、耆那教艺术品而闻名，是研究印度文明的重要机构。',
        location: '印度·新德里',
        established: '1949年',
        collections: '超过20万件文物',
        highlights: ['印度教雕塑', '佛教艺术品', '耆那教文物', '古代钱币', '印度细密画'],
        website: '暂无',
        openingHours: '暂无'
      },
      '巴西国家博物馆': {
        detailInfo: '巴西国家博物馆（Museu Nacional），是巴西最重要的自然历史和人类学博物馆，位于里约热内卢。收藏有大量南美洲的文物和标本，以收藏古生物化石、印第安文物而闻名，是研究南美洲文明的重要机构。',
        location: '巴西·里约热内卢',
        established: '1818年',
        collections: '超过2000万件标本',
        highlights: ['古生物化石', '印第安文物', '南美洲文物', '自然历史标本', '人类学藏品'],
        website: '暂无',
        openingHours: '暂无'
      },
      '墨西哥国家人类学博物馆': {
        detailInfo: '墨西哥国家人类学博物馆（Museo Nacional de Antropología），是墨西哥最重要的博物馆，位于墨西哥城。收藏有大量中美洲古代文明的文物，以收藏玛雅、阿兹特克文物而闻名，是研究中美洲文明的重要机构。',
        location: '墨西哥·墨西哥城',
        established: '1964年',
        collections: '超过60万件文物',
        highlights: ['阿兹特克太阳石', '玛雅文物', '奥尔梅克文明', '特奥蒂瓦坎文物', '中美洲古代文明'],
        website: 'https://www.mna.inah.gob.mx',
        openingHours: '09:00-17:00，周一闭馆'
      },
      '澳大利亚国家博物馆': {
        detailInfo: '澳大利亚国家博物馆（National Museum of Australia），是澳大利亚最重要的博物馆，位于堪培拉。收藏有大量澳大利亚原住民文物和自然历史标本，以收藏原住民艺术品、澳大利亚历史文物而闻名，是研究澳大利亚文化的重要机构。',
        location: '澳大利亚·堪培拉',
        established: '2001年3月11日',
        collections: '超过25万件文物',
        highlights: ['原住民艺术品', '澳大利亚历史文物', '自然历史标本', '殖民时期文物', '现代澳大利亚文化'],
        website: 'https://www.nma.gov.au',
        openingHours: '09:00-17:00，周一至周日'
      },
      '开普敦南非博物馆': {
        detailInfo: '开普敦南非博物馆（Iziko South African Museum），是南非重要的自然历史博物馆，位于开普敦。收藏有大量非洲的文物和标本，以收藏古人类化石、非洲艺术品而闻名，是研究非洲文明的重要机构。',
        location: '南非·开普敦',
        established: '1825年',
        collections: '超过150万件标本',
        highlights: ['古人类化石', '非洲艺术品', '自然历史标本', '南非历史文物', '海洋生物标本'],
        website: 'https://www.iziko.org.za',
        openingHours: '09:00-17:00，周一至周日'
      },
      '陕西历史博物馆': {
        detailInfo: '陕西历史博物馆（Shaanxi History Museum），是中国重要的历史博物馆，位于古都西安。收藏有大量周、秦、汉、唐等朝代的文物，以收藏兵马俑、唐代文物而闻名，是研究中国古代历史的重要机构。',
        location: '中国·西安市雁塔区小寨东路91号',
        established: '1991年6月20日',
        collections: '超过37万件文物',
        highlights: ['兵马俑', '唐代文物', '周代青铜器', '汉代文物', '唐代壁画'],
        website: 'https://www.sxhm.com',
        openingHours: '08:30-18:00（旺季3月15日-11月14日），09:00-17:30（淡季11月15日-次年3月14日），周一闭馆'
      },
      '南京博物院': {
        detailInfo: '南京博物院（Nanjing Museum），是中国重要的综合性博物馆，位于南京。收藏有大量中国古代文物，以收藏明清文物、书画、陶瓷而闻名，是研究中国历史文化的重要机构。',
        location: '中国·南京市玄武区中山东路321号',
        established: '1933年',
        collections: '超过43万件文物',
        highlights: ['明清文物', '古代书画', '陶瓷精品', '玉器', '古代工艺品'],
        website: 'https://www.njmuseum.com',
        openingHours: '09:00-17:00，周一闭馆（法定节假日除外）'
      },
      '台北故宫博物院': {
        detailInfo: '台北故宫博物院（National Palace Museum），位于台北，是综合性博物馆。收藏有大量中国古代文物和艺术品，以收藏《清明上河图》、《富春山居图》等名作而闻名，是研究中华文明的重要机构。',
        location: '中国·台北市士林区至善路二段221号',
        established: '1965年11月12日',
        collections: '超过69万件文物',
        highlights: ['《清明上河图》', '《富春山居图》', '翠玉白菜', '毛公鼎', '古代书画'],
        website: 'https://www.npm.gov.tw',
        openingHours: '08:30-18:30，周一闭馆'
      },
      '维多利亚与阿尔伯特博物馆': {
        detailInfo: '维多利亚与阿尔伯特博物馆（Victoria and Albert Museum），是英国重要的装饰艺术和设计博物馆，位于伦敦。收藏有大量装饰艺术品、服装、珠宝等，是研究装饰艺术和设计历史的重要机构。',
        location: '英国·伦敦南肯辛顿',
        established: '1852年',
        collections: '超过230万件藏品',
        highlights: ['装饰艺术品', '服装和纺织品', '珠宝', '家具', '陶瓷和玻璃'],
        website: 'https://www.vam.ac.uk',
        openingHours: '10:00-17:45，周五延长至22:00，周一至周日'
      },
      '波士顿美术博物馆': {
        detailInfo: '波士顿美术博物馆（Museum of Fine Arts, Boston），是美国重要的艺术博物馆，位于波士顿。收藏有大量古代和现代艺术作品，以收藏亚洲艺术、印象派作品而闻名，是研究世界艺术的重要机构。',
        location: '美国·波士顿亨廷顿大道465号',
        established: '1870年',
        collections: '超过45万件艺术品',
        highlights: ['亚洲艺术', '印象派绘画', '古埃及艺术', '美国艺术', '欧洲绘画'],
        website: 'https://www.mfa.org',
        openingHours: '10:00-17:00，周三至周五延长至22:00，周一和周二闭馆'
      }
    };

    const defaultInfo: MuseumInfo = {
      detailInfo: this.museumDescription,
      location: '位置信息待补充',
      established: '建立时间待补充',
      collections: '藏品数量待补充',
      highlights: ['特色展品1', '特色展品2', '特色展品3'],
      website: '暂无',
      openingHours: '暂无'
    };
    const info: MuseumInfo = museumInfoMap[name] || defaultInfo;

    this.detailInfo = info.detailInfo;
    this.location = info.location;
    this.established = info.established;
    this.collections = info.collections;
    this.highlights = info.highlights;
    this.website = info.website;
    this.openingHours = info.openingHours;
    this.architecture = info.architecture || null;
  }

  async recordView() {
    try {
      const context = getContext(this) as Context;
      this.preferencesStore = await preferences.getPreferences(context, 'user_data');
      if (this.preferencesStore) {
        const exploredMuseums = await this.preferencesStore.get('exploredMuseums', 0) as number;
        const exploredList = await this.preferencesStore.get('exploredMuseumList', '[]') as string;
        let list: number[] = JSON.parse(exploredList);
        
        if (!list.includes(this.museumId)) {
          list.push(this.museumId);
          await this.preferencesStore.put('exploredMuseums', exploredMuseums + 1);
          await this.preferencesStore.put('exploredMuseumList', JSON.stringify(list));
          await this.preferencesStore.flush();
        }
      }
    } catch (error) {
      console.error('记录浏览失败:', error);
    }
  }

  setDefaultInfo() {
    this.detailInfo = this.museumDescription;
    this.location = '位置信息待补充';
    this.established = '建立时间待补充';
    this.collections = '藏品数量待补充';
    this.highlights = ['特色展品1', '特色展品2', '特色展品3'];
    this.website = '暂无';
    this.openingHours = '暂无';
  }

  build() {
    Scroll() {
      Column() {
        // 导航栏
        this.NavBar()

        // 博物馆图片
        this.MuseumImage()

        // 基本信息
        this.BasicInfo()

        // 详细介绍
        this.DetailSection()

        // 特色展品
        this.HighlightsSection()

        // 建筑特色
        if (this.architecture) {
          this.ArchitectureSection()
        }

        // 知识问答入口
        this.QuizSection()
      }
      .width('100%')
      .backgroundColor($r('app.color.app_background'))
    }
  }

  @Builder
  NavBar() {
    Row() {
      Image($r('app.media.startIcon'))
        .width(24)
        .height(24)
        .margin({ right: 8 })
        .onClick(() => {
          router.back() as void
        })
      Text('博物馆详情')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_inverse'))

      Blank()
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.primary_color'))
  }

  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color($r('app.color.primary_light'))
      Text('正在加载博物馆信息...')
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
  MuseumImage() {
    Stack() {
      Image(this.getMuseumImage(this.museumImage))
        .width('100%')
        .height(250)
        .objectFit(ImageFit.Cover)
        .alt(this.museumName)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.shadow_color'))

      Column() {
        Text(this.museumName)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_inverse'))
          .textAlign(TextAlign.Center)
          .textShadow({ radius: 8, color: '#000000', offsetX: 2, offsetY: 2 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 20, right: 20 })
    }
    .width('100%')
    .height(250)
  }

  @Builder
  BasicInfo() {
    Column() {
      Row() {
        Column() {
          Text('位置')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.location)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('建立时间')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.established)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('藏品数量')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.collections)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 16 })

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(1)
        .margin({ bottom: 16 })

      Row() {
        Text('官方网站')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ right: 12 })
        
        if (this.website !== '暂无' && this.website !== '') {
          Text(this.website)
            .fontSize(14)
            .fontColor($r('app.color.primary_light'))
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        } else {
          Text('暂无')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .fontWeight(FontWeight.Medium)
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 16 })

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(1)
        .margin({ bottom: 16 })

      Row() {
        Text('开馆时间')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ right: 12 })
        
        if (this.openingHours !== '暂无' && this.openingHours !== '') {
          Text(this.openingHours)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        } else {
          Text('暂无')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
            .fontWeight(FontWeight.Medium)
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
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
  HighlightsSection() {
    Column() {
      Text('特色展品')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Column() {
        ForEach(this.highlights, (item: string, index: number) => {
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

            if (index < this.highlights.length - 1) {
              Divider()
                .color($r('app.color.divider_color'))
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
  ArchitectureSection() {
    Column() {
      Text('建筑特色')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 20 })
        .alignSelf(ItemAlign.Start)

      // 建筑风格
      Column() {
        Text('建筑风格')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a237e')
          .margin({ bottom: 8 })
          .alignSelf(ItemAlign.Start)

        Text(this.architecture!.style)
          .fontSize(15)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(22)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#f5f5f5')
      .borderRadius(12)
      .margin({ bottom: 16 })

      // 建筑图片轮播
      if (this.architecture!.buildingImages && this.architecture!.buildingImages.length > 0) {
        Swiper() {
          ForEach(this.architecture!.buildingImages, (imageName: string, index: number) => {
            Image(this.getMuseumImage(imageName))
              .width('100%')
              .height(200)
              .objectFit(ImageFit.Cover)
              .borderRadius(12)
          })
        }
        .cachedCount(2)
        .index(0)
        .indicator(true)
        .loop(true)
        .duration(500)
        .itemSpace(0)
        .width('100%')
        .height(200)
        .margin({ bottom: 16 })
      }

      // 设计师信息卡片
      Column() {
        Text('建筑设计师')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a237e')
          .margin({ bottom: 12 })
          .alignSelf(ItemAlign.Start)

        Column() {
          Row() {
            Column() {
              Text(this.architecture!.architect.name)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 8 })

              Row() {
                Text(this.architecture!.architect.period)
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .backgroundColor('#e8eaf6')
                  .borderRadius(8)
                  .margin({ right: 8 })

                Text(this.architecture!.architect.nationality)
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .backgroundColor('#e8eaf6')
                  .borderRadius(8)
              }
              .width('100%')
              .margin({ bottom: 12 })

              Text(this.architecture!.architect.description)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .lineHeight(20)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .border({
          width: 1,
          color: '#e0e0e0',
          style: BorderStyle.Solid
        })
        .margin({ bottom: 16 })
      }
      .width('100%')

      // 设计理念
      Column() {
        Text('设计理念')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a237e')
          .margin({ bottom: 8 })
          .alignSelf(ItemAlign.Start)

        Text(this.architecture!.designConcept)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(22)
          .textAlign(TextAlign.JUSTIFY)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#f5f5f5')
      .borderRadius(12)
      .margin({ bottom: 16 })

      // 建筑特色
      if (this.architecture!.features && this.architecture!.features.length > 0) {
        Column() {
          Text('建筑特色')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 12 })
            .alignSelf(ItemAlign.Start)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.architecture!.features, (feature: string, index: number) => {
              Text(feature)
                .fontSize(13)
                .fontColor($r('app.color.primary_light'))
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .backgroundColor('#e8eaf6')
                .borderRadius(16)
                .margin({ right: 8, bottom: 8 })
            })
          }
          .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
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
  QuizSection() {
    Column() {
      Text('知识问答')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Text('测试您对该博物馆的了解程度')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 20 })
        .alignSelf(ItemAlign.Start)

      Button() {
        Row() {
          Text('开始答题')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_inverse'))
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height(50)
      .backgroundColor('#3949ab')
      .borderRadius(12)
      .onClick(() => {
        this.navigateToQuiz();
      })
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

  // 获取博物馆对应的知识问答模块ID
  getQuizModuleId(museumName: string): string {
    const museumToModuleMap: Record<string, string> = {
      '故宫博物院': 'forbidden_city',
      '中国国家博物馆': 'national_museum',
      '卢浮宫': 'louvre',
      '大英博物馆': 'british_museum',
      '大都会艺术博物馆': 'metropolitan',
      '艾尔米塔什博物馆': 'hermitage',
      '东京国立博物馆': 'tokyo_national',
      '上海博物馆': 'shanghai_museum',
      '梵蒂冈博物馆': 'vatican_museums',
      '普拉多博物馆': 'prado',
      '乌菲兹美术馆': 'uffizi',
      '埃及博物馆': 'egyptian_museum',
      '古根海姆博物馆': 'guggenheim',
      '泰特现代美术馆': 'tate_modern',
      '奥赛博物馆': 'orsay',
      '芝加哥艺术博物馆': 'chicago_art',
      '柏林国家博物馆': 'berlin_state',
      '阿姆斯特丹国家博物馆': 'rijksmuseum',
      '首尔国立中央博物馆': 'seoul_national',
      '印度国家博物馆': 'india_national',
      '巴西国家博物馆': 'brazil_national',
      '墨西哥国家人类学博物馆': 'mexico_anthropology',
      '澳大利亚国家博物馆': 'australia_national',
      '开普敦南非博物馆': 'cape_town_museum',
      '陕西历史博物馆': 'shaanxi_history',
      '南京博物院': 'nanjing_museum',
      '台北故宫博物院': 'taipei_palace',
      '维多利亚与阿尔伯特博物馆': 'vam',
      '波士顿美术博物馆': 'boston_mfa'
    };
    return museumToModuleMap[museumName] || '';
  }

  // 跳转到知识问答页面
  navigateToQuiz() {
    const moduleId = this.getQuizModuleId(this.museumName);
    if (moduleId) {
      router.pushUrl({
        url: 'pages/Quiz',
        params: {
          moduleId: moduleId
        }
      } as router.RouterOptions).then(() => {
        // 跳转成功
      }).catch((err: Error) => {
        console.error('跳转失败:', err);
      });
    }
  }

  getMuseumImage(imageName: string): Resource | string {
    // 使用本地图片资源，与images文件夹中的图片对应
    const imageMap: Record<string, Resource> = {
      '故宫': $rawfile('故宫.png'),
      '大英博物馆': $rawfile('大英博物馆.png'),
      '卢浮宫': $rawfile('卢浮宫.png'),
      '大都会艺术博物馆': $rawfile('大都会艺术博物馆.png'),
      '艾尔米塔什博物馆': $rawfile('艾尔米塔什博物馆.webp'),
      '东京国立博物馆': $rawfile('东京国立博物馆.jpg'),
      '故宫博物院': $rawfile('故宫.png'),
      '中国国家博物馆': $rawfile('中国国家博物馆.webp'),
      '上海博物馆': $rawfile('上海博物馆.jpg'),
      '梵蒂冈博物馆': $rawfile('梵蒂冈博物馆.jpg'),
      '普拉多博物馆': $rawfile('普拉多博物馆.webp'),
      '乌菲兹美术馆': $rawfile('乌菲兹美术馆.jpg'),
      '埃及博物馆': $rawfile('埃及博物馆.webp'),
      '古根海姆博物馆': $rawfile('古根海姆博物馆.jpg'),
      '泰特现代美术馆': $rawfile('泰特现代美术馆.webp'),
      '奥赛博物馆': $rawfile('奥赛博物馆.webp'),
      '芝加哥艺术博物馆': $rawfile('芝加哥艺术博物馆.jpg'),
      '柏林国家博物馆': $rawfile('柏林国家博物馆.webp'),
      '阿姆斯特丹国家博物馆': $rawfile('阿姆斯特丹国家博物馆.webp'),
      '首尔国立中央博物馆': $rawfile('首尔国立中央博物馆.webp'),
      '印度国家博物馆': $rawfile('印度国家博物馆.jpg'),
      '巴西国家博物馆': $rawfile('巴西国家博物馆.webp'),
      '墨西哥国家人类学博物馆': $rawfile('墨西哥国家人类学博物馆.webp'),
      '澳大利亚国家博物馆': $rawfile('澳大利亚国家博物馆.jpg'),
      '开普敦南非博物馆': $rawfile('开普敦南非博物馆.webp'),
      '陕西历史博物馆': $rawfile('陕西历史博物馆.webp'),
      '南京博物院': $rawfile('南京博物馆.jpg'), // 图片文件名是南京博物馆.jpg
      '台北故宫博物院': $rawfile('台北故宫博物院.jpg'),
      '维多利亚与阿尔伯特博物馆': $rawfile('维多利亚与阿尔伯特博物馆.webp'),
      '波士顿美术博物馆': $rawfile('波士顿美术博物馆.jpg')
    };
    return imageMap[imageName] || $rawfile('故宫.png');
  }
}
