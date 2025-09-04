import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homelink_pendant_app/models/alert.dart';
import 'package:video_player/video_player.dart';

// TODO: Refactor this widget to be more modular and split out a bunch of the smaller widgets into their own classes.
class LiveAlertCard extends StatefulWidget {
  final Alert alert;
  final VoidCallback? onResolved;

  const LiveAlertCard({super.key, required this.alert, this.onResolved});

  @override
  State<LiveAlertCard> createState() => _LiveAlertCardState();
}

class _LiveAlertCardState extends State<LiveAlertCard>
    with SingleTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _removeOffsetAnimation;

  // TODO: This should be an enum, not three booleans.
  bool _expanded = false;
  bool _resolved = false;
  bool _removing = false;

  // Video Library
  // Late initialization of video controller
  late VideoPlayerController _videoController;

  // Future for video initialization
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(2.0, 0), // Off-screen right
          end: Offset.zero, // Center
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _removeOffsetAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-2.0, 0), // Slide left
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _animationController.forward();

    // Initialize the video controller with a the local video
    _videoController = VideoPlayerController.asset('assets/homelink_tick.mp4');

    // Store the initialization Future. Needed to allow correct sizing of the widget once the video is loaded.
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cleanup all controllers when widgets are destroyed
    _animationController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _resolveCard() {
    setState(() {
      _resolved = true;
      _expanded = false;
      _videoController.play();

      // TODO: Small issue with video sometimes going black on last frame. Pause it early to avoid this.
      Future.delayed(Duration(seconds: 2), () {
        _videoController.pause();

        // After animation has played, move the card off-screen for it to be destroyed.
        setState(() {
          _removing = true;
        });
        _animationController.reset();
        _animationController.forward();

        Future.delayed(Duration(milliseconds: 600), () {
          // Callback should also delete it from Firestore DB.
          if (widget.onResolved != null) {
            widget.onResolved!();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _resolved ? Color(0xFF488333) : Color(0xFFEC0035);

    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        child: SlideTransition(
          position: _removing ? _removeOffsetAnimation : _offsetAnimation,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,

            // GestureDetector to handle taps for expanding/collapsing the card
            child: GestureDetector(
              onTap: !_resolved ? _toggleExpand : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,

                  // Borders must be a non-zero value otherwise they throw an error.
                  border: Border(
                    left: BorderSide(color: borderColor, width: 8),
                    top: BorderSide(
                      color: borderColor,
                      width: _resolved ? 0.1 : 2,
                    ),
                    right: BorderSide(
                      color: borderColor,
                      width: _resolved ? 0.1 : 2,
                    ),
                    bottom: BorderSide(
                      color: borderColor,
                      width: _resolved ? 0.1 : 2,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_resolved)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Resolved',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        32,
                        _resolved ? 16 : 32,
                        32,
                        32,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    // Format date to display relative from now.
                                    _formatDate(widget.alert.date),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Image(
                                    image: AssetImage(
                                      'assets/alert_with_resident.png',
                                    ),
                                    width: 48,
                                    height: 48,
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.alert.reason,
                                      style: TextStyle(
                                        color: Color(0xFFEC0035),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'at ${widget.alert.addressLine1}, ${widget.alert.postcode}\nby ${widget.alert.senderName}',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            alignment: Alignment.topCenter,
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              height: _expanded ? null : 0,

                              // TODO: Make this *much* more concise.
                              child: Column(
                                children: [
                                  SizedBox(height: 32),
                                  _buildActionButton(
                                    "Everything's OK",
                                    _resolveCard,
                                  ),
                                  SizedBox(height: 16),
                                  _buildActionButton(
                                    'Going to property now',
                                    () => _placeholderDialogBuilder(
                                      context,
                                      'Pressing this will action the card on the backend and dismiss it from live view, but your status will be shown to other carers.',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildActionButton(
                                    'Call Doctor',
                                    () => _placeholderDialogBuilder(
                                      context,
                                      'Pressing this will launch the native call app on the user\'s phone, prefilled with the doctor\'s contact number. The number will be pulled from the patient record via an additional lookup.',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildActionButton(
                                    'I cannot visit',
                                    () => _placeholderDialogBuilder(
                                      context,
                                      'Pressing this will it from your live view, but the stats will still be shown to other carers as unresolved.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            alignment: Alignment.topCenter,
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              height: _resolved ? null : 0,
                              child: Column(
                                children: [
                                  SizedBox(height: 32),
                                  Text(
                                    'Thank you for your update!',
                                    style: TextStyle(
                                      color: Color(0xFF4083B9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  /* TODO: Crop and re-render video so we can cut a full circle out.
                                  ** See: https://medium.com/easy-flutter/transparent-video-in-flutter-my-victory-after-many-failed-attempts-206c37598c40
                                  */
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      height: 125,
                                      child: FutureBuilder(
                                        future: _initializeVideoPlayerFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return AspectRatio(
                                              aspectRatio: _videoController
                                                  .value
                                                  .aspectRatio,
                                              child: VideoPlayer(
                                                _videoController,
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TODO: Move these functions below out to a helper file, separate business logic when possible.
  String _formatDate(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes <= 10) {
      return '${difference.inMinutes} min ago';
    } else {
      return '+10 min ago';
    }
  }

  // TODO: This should be in it's own file.
  Widget _buildActionButton(String text, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF4A90E2), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF4A90E2),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // TODO: This should be in it's own file; will be removed when all screens are implemented.
  Future<void> _placeholderDialogBuilder(
    BuildContext context,
    String description,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Yet Implemented'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
