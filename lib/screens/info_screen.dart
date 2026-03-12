import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        centerTitle: !isDesktop,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用信息卡片
            _buildAppInfoCard(context),
            
            const SizedBox(height: 24),
            
            // 功能介绍
            _buildFeaturesSection(context),
            
            const SizedBox(height: 24),
            
            // 技术栈
            _buildTechStackSection(context),
            
            const SizedBox(height: 24),
            
            // 联系我们
            _buildContactSection(context),
            
            const SizedBox(height: 24),
            
            // 开源协议
            _buildLicenseSection(context),
            
            const SizedBox(height: 32),
            
            // 版本信息
            Center(
              child: Text(
                '版本 1.0.0 (Build 1)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAppInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.apps,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Multi-Platform App',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '跨平台应用开发示例',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '这是一个使用 Flutter 框架开发的多平台应用示例，\n支持 Android、iOS、Windows 等多种平台。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.devices,
        'title': '多平台支持',
        'description': '一套代码，同时支持 Android、iOS、Windows、Web',
      },
      {
        'icon': Icons.responsive_layout,
        'title': '响应式设计',
        'description': '自适应手机、平板、桌面不同屏幕尺寸',
      },
      {
        'icon': Icons.navigation,
        'title': '智能导航',
        'description': '根据设备类型自动切换导航方式',
      },
      {
        'icon': Icons.image,
        'title': '图片浏览',
        'description': '支持网格和列表视图，全屏查看',
      },
      {
        'icon': Icons.search,
        'title': '搜索筛选',
        'description': '支持关键词搜索和分类筛选',
      },
      {
        'icon': Icons.dark_mode,
        'title': '深色模式',
        'description': '支持浅色和深色主题切换',
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '功能特性',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                feature['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['description'] as String,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildTechStackSection(BuildContext context) {
    final techs = [
      {'name': 'Flutter', 'version': '3.24+', 'desc': 'UI框架'},
      {'name': 'Dart', 'version': '3.0+', 'desc': '编程语言'},
      {'name': 'Material 3', 'version': '', 'desc': '设计系统'},
      {'name': 'go_router', 'version': '^12.1', 'desc': '路由管理'},
      {'name': 'flutter_riverpod', 'version': '^2.4', 'desc': '状态管理'},
      {'name': 'responsive_framework', 'version': '^1.1', 'desc': '响应式布局'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '技术栈',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: techs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tech = techs[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      tech['name']![0],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                title: Text(tech['name']!),
                subtitle: Text(tech['desc']!),
                trailing: tech['version']!.isNotEmpty
                    ? Chip(
                        label: Text(tech['version']!, style: const TextStyle(fontSize: 12)),
                        padding: EdgeInsets.zero,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '联系我们',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('电子邮件'),
                subtitle: const Text('support@example.com'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl('mailto:support@example.com'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('官方网站'),
                subtitle: const Text('https://flutter.dev'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl('https://flutter.dev'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('GitHub'),
                subtitle: const Text('github.com/flutter'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl('https://github.com/flutter'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLicenseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '开源许可',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MIT License',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Copyright (c) 2024 Multi-Platform App\n\n'
                  'Permission is hereby granted, free of charge, to any person obtaining a copy '
                  'of this software and associated documentation files...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // 查看完整许可
                    showLicensePage(
                      context: context,
                      applicationName: 'Multi-Platform App',
                      applicationVersion: '1.0.0',
                    );
                  },
                  child: const Text('查看完整许可协议'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
