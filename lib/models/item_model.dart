class ItemModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime date;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  
  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
    this.tags = const [],
    this.metadata = const {},
  });
  
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: json['metadata'] ?? {},
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'date': date.toIso8601String(),
      'tags': tags,
      'metadata': metadata,
    };
  }
}

// 示例数据
final List<ItemModel> sampleItems = [
  ItemModel(
    id: 1,
    title: '美丽的山脉',
    description: '这是一幅壮观的山脉风景照片，展现了大自然的鬼斧神工。清晨的阳光洒落在雪峰之上，营造出金色的光芒。',
    imageUrl: 'https://picsum.photos/800/600?random=1',
    category: '风景',
    date: DateTime(2024, 1, 15),
    tags: ['山脉', '自然', '风景', '旅行'],
    metadata: {'location': '阿尔卑斯山', 'camera': 'Sony A7R IV'},
  ),
  ItemModel(
    id: 2,
    title: '城市夜景',
    description: '繁华都市的夜晚，霓虹灯光闪烁，车水马龙。这张照片捕捉了城市生活的活力与节奏。',
    imageUrl: 'https://picsum.photos/800/600?random=2',
    category: '城市',
    date: DateTime(2024, 2, 20),
    tags: ['城市', '夜景', '灯光', '建筑'],
    metadata: {'location': '东京', 'camera': 'Canon R5'},
  ),
  ItemModel(
    id: 3,
    title: '海滨日落',
    description: '宁静的海滩上，夕阳西下，天空被染成橙红色。海浪轻轻拍打着沙滩，带来内心的平静。',
    imageUrl: 'https://picsum.photos/800/600?random=3',
    category: '风景',
    date: DateTime(2024, 3, 10),
    tags: ['海滩', '日落', '海洋', '放松'],
    metadata: {'location': '马尔代夫', 'camera': 'Nikon Z8'},
  ),
  ItemModel(
    id: 4,
    title: '古镇小巷',
    description: '古老的石板路，两旁是传统的中式建筑。岁月在这里留下了痕迹，诉说着历史的故事。',
    imageUrl: 'https://picsum.photos/800/600?random=4',
    category: '人文',
    date: DateTime(2024, 4, 5),
    tags: ['古镇', '历史', '文化', '建筑'],
    metadata: {'location': '丽江', 'camera': 'Fujifilm GFX100'},
  ),
  ItemModel(
    id: 5,
    title: '森林深处',
    description: '茂密的原始森林，阳光透过树叶的缝隙洒下斑驳的光影。这里是远离尘嚣的世外桃源。',
    imageUrl: 'https://picsum.photos/800/600?random=5',
    category: '自然',
    date: DateTime(2024, 5, 12),
    tags: ['森林', '自然', '徒步', '探险'],
    metadata: {'location': '亚马逊雨林', 'camera': 'Sony A1'},
  ),
  ItemModel(
    id: 6,
    title: '现代建筑',
    description: '流线型的现代建筑设计，玻璃幕墙反射着天空的色彩。这是人类智慧与创造力的结晶。',
    imageUrl: 'https://picsum.photos/800/600?random=6',
    category: '建筑',
    date: DateTime(2024, 6, 8),
    tags: ['建筑', '现代', '设计', '艺术'],
    metadata: {'location': '迪拜', 'camera': 'Hasselblad X2D'},
  ),
  ItemModel(
    id: 7,
    title: '美食佳肴',
    description: '精致的美食摆盘，色彩鲜艳，令人垂涎。美食不仅是味觉的享受，更是视觉的艺术。',
    imageUrl: 'https://picsum.photos/800/600?random=7',
    category: '美食',
    date: DateTime(2024, 7, 22),
    tags: ['美食', '料理', '艺术', '生活'],
    metadata: {'location': '巴黎', 'camera': 'Leica Q3'},
  ),
  ItemModel(
    id: 8,
    title: '动物世界',
    description: '野生动物在自然栖息地中的精彩瞬间。每一个生命都值得被尊重和保护。',
    imageUrl: 'https://picsum.photos/800/600?random=8',
    category: '动物',
    date: DateTime(2024, 8, 18),
    tags: ['动物', '野生', '自然', '保护'],
    metadata: {'location': '肯尼亚', 'camera': 'Canon R3'},
  ),
  ItemModel(
    id: 9,
    title: '星空银河',
    description: '远离城市灯光污染的旷野，满天繁星闪烁，银河横跨天际。这是宇宙最美的画卷。',
    imageUrl: 'https://picsum.photos/800/600?random=9',
    category: '天文',
    date: DateTime(2024, 9, 30),
    tags: ['星空', '银河', '天文', '夜景'],
    metadata: {'location': '冰岛', 'camera': 'Nikon Z9'},
  ),
  ItemModel(
    id: 10,
    title: '人文纪实',
    description: '街头巷尾的生活瞬间，记录普通人的喜怒哀乐。摄影是时间的艺术，定格永恒的瞬间。',
    imageUrl: 'https://picsum.photos/800/600?random=10',
    category: '人文',
    date: DateTime(2024, 10, 25),
    tags: ['人文', '纪实', '街头', '生活'],
    metadata: {'location': '纽约', 'camera': 'Ricoh GR III'},
  ),
  ItemModel(
    id: 11,
    title: '花卉微距',
    description: '微距镜头下的花朵，展现肉眼难以察觉的细节之美。每一片花瓣都精致如艺术品。',
    imageUrl: 'https://picsum.photos/800/600?random=11',
    category: '微距',
    date: DateTime(2024, 11, 14),
    tags: ['花卉', '微距', '自然', '细节'],
    metadata: {'location': '植物园', 'camera': 'Olympus OM-1'},
  ),
  ItemModel(
    id: 12,
    title: '雪山湖泊',
    description: '高山湖泊倒映着雪峰的倒影，如镜面般平静。这是大自然最纯净的画卷。',
    imageUrl: 'https://picsum.photos/800/600?random=12',
    category: '风景',
    date: DateTime(2024, 12, 1),
    tags: ['雪山', '湖泊', '风景', '自然'],
    metadata: {'location': '瑞士', 'camera': 'Phase One XF'},
  ),
];

final List<String> categories = ['全部', '风景', '城市', '自然', '人文', '建筑', '美食', '动物', '天文', '微距'];
