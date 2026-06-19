import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/community_post.dart';
import '../data/tarot_data.dart';
import 'glass_container.dart';
import '../screens/community_detail_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class CommunityFeedItem extends StatelessWidget {
  final CommunityPost post;

  const CommunityFeedItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final nickname = post.authorNickname.isNotEmpty ? post.authorNickname : AppLocalizations.of(context)!.communityNoName;
    final formattedDate = DateFormat('yyyy.MM.dd HH:mm').format(post.createdAt);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassContainer(
        borderRadius: 16,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityDetailScreen(post: post),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Nickname & Date)
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 16,
                      child: Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Content (Cards & Text)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.cardIds.isNotEmpty) ...[
                      _buildThumbnail(context, post.cardIds.first),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.question.isNotEmpty && post.question != '타로 리딩') ...[
                            Text(
                              'Q. ${post.question}',
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            post.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 8),
                
                // Footer (Likes & Comments)
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('${AppLocalizations.of(context)!.communityLike} ${post.likeCount}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text('${AppLocalizations.of(context)!.communityComments} ${post.commentCount}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, String cardId) {
    final card = getTarotDeck(context).firstWhere((c) => c.id == cardId, orElse: () => getTarotDeck(context).first);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        card.imagePath,
        width: 60,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}
