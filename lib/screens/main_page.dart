

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:listenandwatch/screens/video_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BucketVideoListPage extends StatefulWidget {
  const BucketVideoListPage({super.key});

  @override
  State<BucketVideoListPage> createState() => _BucketVideoListPageState();
}

class _BucketVideoListPageState extends State<BucketVideoListPage> {
  late Future<List<Map<String, String>>> _videoData;

  @override
  void initState() {
    super.initState();
    _videoData = _fetchVideoData();
  }

  Future<List<Map<String, String>>> _fetchVideoData() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('clips').select('''
    thumbnail_url,
    subtitle_url,
    video_url,
    title,
    created_at,
    profiles:user_id(
      full_name,
      avatar_url
    )
    
    ''');
    
    return response.map((item) {

      final thumbnailUrl = 'https://hjlmhexenfqtagfwniot.supabase.co/storage/v1/object/public/thumbnails/${item['thumbnail_url'].toString()}';
      final subtitleUrl = 'https://hjlmhexenfqtagfwniot.supabase.co/storage/v1/object/public/subtitles/${item['subtitle_url'].toString()}';
      final videoUrl = 'https://hjlmhexenfqtagfwniot.supabase.co/storage/v1/object/public/videos/${item['video_url'].toString()}';
      final authorName = item['profiles']['full_name'].toString();
      final authorAvatarUrl = 'https://hjlmhexenfqtagfwniot.supabase.co/storage/v1/object/public/avatars/${item['profiles']['avatar_url'].toString()}';

      return {
        'id': item['id'].toString(),
        'thumbnail': thumbnailUrl,
        'subtitle_url': subtitleUrl,
        'video_url': videoUrl,
        'title': item['title'].toString(),
        'author_name': authorName,
        'author_avatar_url': authorAvatarUrl,
        'created_at': item['created_at'].toString()
      };
    }).toList();
    
   
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Videos'),
          backgroundColor: Colors.white,
          elevation: 0.3,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: FutureBuilder<List<Map<String, String>>>(
          future: _videoData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Skeleton loader (YouTube-style shimmer)
              return ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => const _VideoSkeleton(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final videos = snapshot.data ?? [];
            if (videos.isEmpty) {
              return const Center(child: Text('No videos found.'));
            }

            return RefreshIndicator(
              onRefresh: () {
                setState(() {
                  _videoData= _fetchVideoData();
                }); 
                return _videoData;
              },
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  final createdAt = video['created_at']?? '';
                          final date = intl.DateFormat.yMMMMd().format(DateTime.parse(createdAt));
                          
              
                  final avatarUrl = video['author_avatar_url'] ?? '';
              
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      GestureDetector(
                        onTap: () {
                          final videoUrl = video['video_url'];
                          final subtitleUrl = video['subtitle_url'];
                          final title = video['title'];
                          
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerPage(
                                videoUrl: videoUrl ?? '',
                                subtitleUrl: subtitleUrl ?? '',
                                title: title ?? '',
                              ),
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            video['thumbnail']!,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                        ),
                      ),
              
                      // Video info section
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black12,
                                    backgroundImage:
                                        NetworkImage(avatarUrl),
                                    onBackgroundImageError: (_, __) {},
                                    child: avatarUrl.isEmpty
                                        ? const Icon(Icons.person, color: Colors.black54)
                                        : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${video['author_name']??''} • $date",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VideoSkeleton extends StatelessWidget {
  const _VideoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 9 / 16,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 100, color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}