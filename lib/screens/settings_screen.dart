import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 设置状态管理
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final accentColorProvider = StateProvider<Color>((ref) => Colors.blue);
final fontSizeProvider = StateProvider<double>((ref) => 1.0);
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final autoPlayEnabledProvider = StateProvider<bool>((ref) => true);
final cacheEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final autoPlayEnabled = ref.watch(autoPlayEnabledProvider);
    final cacheEnabled = ref.watch(cacheEnabledProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: !isDesktop,
      ),
      body: ListView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        children: [
          // 外观设置
          _buildSectionTitle(context, '外观'),
          _buildThemeCard(context, ref, themeMode),
          _buildColorCard(context, ref, accentColor),
          _buildFontSizeCard(context, ref, fontSize),
          
          const SizedBox(height: 24),
          
          // 通用设置
          _buildSectionTitle(context, '通用'),
          _buildSwitchTile(
            context: context,
            icon: Icons.notifications_outlined,
            title: '通知',
            subtitle: '接收推送通知',
            value: notificationsEnabled,
            onChanged: (value) => ref.read(notificationsEnabledProvider.notifier).state = value,
          ),
          _buildSwitchTile(
            context: context,
            icon: Icons.play_circle_outline,
            title: '自动播放',
            subtitle: '轮播图自动播放',
            value: autoPlayEnabled,
            onChanged: (value) => ref.read(autoPlayEnabledProvider.notifier).state = value,
          ),
          _buildSwitchTile(
            context: context,
            icon: Icons.storage_outlined,
            title: '缓存',
            subtitle: '启用图片缓存',
            value: cacheEnabled,
            onChanged: (value) => ref.read(cacheEnabledProvider.notifier).state = value,
          ),
          
          const SizedBox(height: 24),
          
          // 数据管理
          _buildSectionTitle(context, '数据'),
          _buildActionTile(
            context: context,
            icon: Icons.delete_outline,
            title: '清除缓存',
            subtitle: '已使用 24.5 MB',
            onTap: () => _showClearCacheDialog(context),
          ),
          _buildActionTile(
            context: context,
            icon: Icons.download_outlined,
            title: '离线内容',
            subtitle: '管理已下载的内容',
            onTap: () {},
          ),
          _buildActionTile(
            context: context,
            icon: Icons.sync_outlined,
            title: '同步设置',
            subtitle: '云端同步偏好设置',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // 关于
          _buildSectionTitle(context, '关于'),
          _buildInfoTile(
            context: context,
            icon: Icons.info_outline,
            title: '版本',
            value: '1.0.0 (Build 1)',
          ),
          _buildInfoTile(
            context: context,
            icon: Icons.update,
            title: '检查更新',
            value: '已是最新版本',
          ),
          
          const SizedBox(height: 32),
          
          // 危险操作
          Center(
            child: TextButton.icon(
              onPressed: () => _showResetDialog(context, ref),
              icon: const Icon(Icons.restore),
              label: const Text('恢复默认设置'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildThemeCard(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '主题模式',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('浅色'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('深色'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('跟随系统'),
                  icon: Icon(Icons.settings_suggest),
                ),
              ],
              selected: {currentMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref.read(themeModeProvider.notifier).state = newSelection.first;
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildColorCard(BuildContext context, WidgetRef ref, Color currentColor) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.color_lens_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '主题色',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = color == currentColor;
                return GestureDetector(
                  onTap: () => ref.read(accentColorProvider.notifier).state = color,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFontSizeCard(BuildContext context, WidgetRef ref, double currentSize) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.text_fields,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '字体大小',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${(currentSize * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: currentSize,
              min: 0.8,
              max: 1.3,
              divisions: 5,
              label: '${(currentSize * 100).toInt()}%',
              onChanged: (value) {
                ref.read(fontSizeProvider.notifier).state = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('小', style: Theme.of(context).textTheme.bodySmall),
                Text('标准', style: Theme.of(context).textTheme.bodySmall),
                Text('大', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
  
  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
  
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存数据吗？这将删除已下载的图片和其他临时文件。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }
  
  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('恢复默认设置'),
        content: const Text('确定要恢复所有设置到默认值吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              // 重置所有设置
              ref.read(themeModeProvider.notifier).state = ThemeMode.system;
              ref.read(accentColorProvider.notifier).state = Colors.blue;
              ref.read(fontSizeProvider.notifier).state = 1.0;
              ref.read(notificationsEnabledProvider.notifier).state = true;
              ref.read(autoPlayEnabledProvider.notifier).state = true;
              ref.read(cacheEnabledProvider.notifier).state = true;
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已恢复默认设置')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('恢复'),
          ),
        ],
      ),
    );
  }
}
