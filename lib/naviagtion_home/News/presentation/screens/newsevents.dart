import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:fluentnow/naviagtion_home/News/businesse_logic/cubitnewsevents/newsevents_cubit.dart';
import 'package:fluentnow/naviagtion_home/News/data/model/news&events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool showNews = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    if (showNews) {
      BlocProvider.of<NewseventsCubit>(context).fetchAllNews();
    } else {
      BlocProvider.of<NewseventsCubit>(context).fetchAllEvents();
    }
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient:
            selected
                ? const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                  // Blue gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.background,
      appBar: AppBar(
        backgroundColor: Mycolors.background,
        title: Text(
          'News & events',
          style: TextStyle(
            color: Mycolors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocConsumer<NewseventsCubit, NewseventsState>(
        listener: (context, state) {
          if (state is NewsError || state is EventsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is NewsError
                      ? state.message
                      : (state as EventsError).message,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Toggle buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedButton(
                        context: context,
                        label: 'News',
                        selected: showNews,
                        onTap: () {
                          if (!showNews) {
                            setState(() {
                              showNews = true;
                              _fetchData();
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAnimatedButton(
                        context: context,
                        label: 'Events',
                        selected: !showNews,
                        onTap: () {
                          if (showNews) {
                            setState(() {
                              showNews = false;
                              _fetchData();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              Expanded(child: _buildContent(state, showNews)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(NewseventsState state, bool showNews) {
    if (showNews) {
      if (state is Newsloading) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading news...'),
            ],
          ),
        );
      } else if (state is Newsloaded) {
        if (state.allNews.isEmpty) {
          return const Center(child: Text('No news available'));
        }
        return _NewsList(newsList: state.allNews);
      } else if (state is NewsError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () =>
                        BlocProvider.of<NewseventsCubit>(
                          context,
                        ).fetchAllNews(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    } else {
      if (state is Eventsloading) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading events...'),
            ],
          ),
        );
      } else if (state is Eventsloaded) {
        if (state.allEvents.isEmpty) {
          return const Center(child: Text('No events available'));
        }
        return _EventsList(eventsList: state.allEvents);
      } else if (state is EventsError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () =>
                        BlocProvider.of<NewseventsCubit>(
                          context,
                        ).fetchAllEvents(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    }
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 48),
          SizedBox(height: 16),
          Text('Tap refresh to load content'),
        ],
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  final List<News> newsList;

  const _NewsList({required this.newsList});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<NewseventsCubit>().fetchAllNews(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return _NewsCard(news: news);
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final News news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Mycolors.cardPanel,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured image with placeholder
            if (news.imageUrl.isNotEmpty)
              Image.network(
                news.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                loadingBuilder: (_, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                },
              )
            else
              Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.article_outlined, size: 48),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row (urgent + featured)
                  if (news.isUrgent)
                    Wrap(
                      spacing: 8,
                      children: [
                        if (news.isUrgent)
                          _NewsBadge(text: 'URGENT', color: Colors.red),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    news.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metadata row
                  Row(
                    children: [
                      // Date
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(news.publishedAt),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Action buttons
                  Wrap(
                    spacing: 12,
                    children: [
                      if (news.externalLink != null)
                        _NewsActionButton(
                          icon: Icons.link,
                          label:
                              'External Link', // or 'Read More', 'Source', etc.
                          onPressed:
                              () => _launchUrl(context, news.externalLink!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $url');
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank', // For web, opens in new tab
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open link: ${e.toString()}')),
        );
      }
      debugPrint('Failed to launch URL: $e');
    }
  }
}

class _NewsBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _NewsBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _NewsActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _NewsActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}

class _EventsList extends StatelessWidget {
  final List<Eventcard> eventsList;

  const _EventsList({required this.eventsList});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () async =>
              BlocProvider.of<NewseventsCubit>(context).fetchAllEvents(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          final event = eventsList[index];
          return _EventCard(event: event);
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Eventcard event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Mycolors.cardPanel,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          if (event.imageUrl.isNotEmpty)
            FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.jpg',
              image: event.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              imageErrorBuilder:
                  (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  ),
            )
          else
            Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.event, size: 48)),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 8),

                // Date & Location Row
                const SizedBox(height: 12),

                // Description
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Read more button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 4),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    eventdetails,
                    arguments: event.id,
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Read More'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
