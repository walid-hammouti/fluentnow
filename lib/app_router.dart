import 'package:fluentnow/auth/businesse_logic/cubit/auth_cubit.dart';
import 'package:fluentnow/auth/data/repository/auth_repo.dart';
import 'package:fluentnow/auth/data/webservices/auth_webservices.dart';
import 'package:fluentnow/auth/presentation/screens/signin_screen.dart';
import 'package:fluentnow/auth/presentation/screens/signup_screen.dart';
import 'package:fluentnow/auth/presentation/screens/welcome_screen.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/businesse_logic/cubit/courselist_cubit.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/data/repository/courseslist_repo.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/data/webservices/courseslist_websrevices.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcorusesdetails/coursedetails_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcourseregistration/course_registration_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitlikedcourses/likedcourses_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/repository/coursedetails_repo.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/webservices/coursedetails_webserivces.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/presentation/screens/coursedetailsscreen.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/businesse_logic/cubit/home_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/repository/home_repo.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/webservices/home_webservices.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/presentation/screens/homescreen.dart';
import 'package:fluentnow/naviagtion_home/Likes/businesse_logic/cubit/likedcourses_cubit.dart';
import 'package:fluentnow/naviagtion_home/Likes/data/repository/likedcourses_repo.dart';
import 'package:fluentnow/naviagtion_home/Likes/data/webservices/likedcourses_webservices.dart';
import 'package:fluentnow/naviagtion_home/News/businesse_logic/cubiteventdetails.dart/event_details_cubit.dart';
import 'package:fluentnow/naviagtion_home/News/businesse_logic/cubitnewsevents/newsevents_cubit.dart';
import 'package:fluentnow/naviagtion_home/News/data/repository/newsevents_repo.dart';
import 'package:fluentnow/naviagtion_home/News/data/webservices/newsevents_webserviecs.dart';
import 'package:fluentnow/naviagtion_home/News/presentation/screens/eventdetails.dart';
import 'package:fluentnow/naviagtion_home/Subscription/businesse_logic/cubit/subscription_cubit.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/repository/subscription_repo.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/webservices/subscription_webservices.dart';
import 'package:fluentnow/naviagtion_home/naviagtion.dart';
import 'package:fluentnow/route_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';

class AppRouter {
  final AuthRepo authrepo;
  final HomeRepo homeRepo;
  final CoursedetailsRepo coursedetailsRepo;
  final CourseslistRepo courseslistRepo;
  final NewseventsRepo newseventsRepo;
  final LikedcoursesRepo likedcoursesRepo;
  final SubscriptionRepo subscriptionRepo;

  AppRouter()
    : authrepo = AuthRepo(AuthWebservices()),
      courseslistRepo = CourseslistRepo(
        courseslistWebsrevices: CourseslistWebsrevices(),
      ),
      subscriptionRepo = SubscriptionRepo(SubscriptionWebservices()),
      likedcoursesRepo = LikedcoursesRepo(LikedcoursesWebservices()),
      coursedetailsRepo = CoursedetailsRepo(CoursedetailsWebserivces()),
      newseventsRepo = NewseventsRepo(NewseventsWebserviecs()),
      homeRepo = HomeRepo(HomeWebservices());
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRoute:
        return FadeRoute(page: RootScreen(), routeName: settings.name);
      case welcomeScreen:
        return FadeRoute(page: WelcomeScreen(), routeName: settings.name);
      case signupScreen:
        return FadeRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SignUpCubit(authrepo)),
              BlocProvider(
                create: (context) => SignInWithGoogleCubit(authrepo),
              ),
            ],
            child: SignupScreen(),
          ),
          routeName: settings.name,
        );
      case signInScreen:
        return FadeRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SignInCubit(authrepo)),
              BlocProvider(
                create: (context) => SignInWithGoogleCubit(authrepo),
              ),
            ],
            child: SignInScreen(),
          ),
          routeName: settings.name,
        );
      case homeNavigationScreen:
        return FadeRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => HomeCubit(homeRepo)),
              BlocProvider(
                create: (context) => CourselistCubit(courseslistRepo),
              ),
              BlocProvider(
                create: (context) => NewseventsCubit(newseventsRepo),
              ),
              BlocProvider(
                create: (context) => LikedcoursesCubit(likedcoursesRepo),
              ),
              BlocProvider(
                create: (context) => SubscriptionCubit(subscriptionRepo),
              ),
            ],
            child: Navigation(),
          ),
          routeName: settings.name,
        );
      case homeScreen:
        return FadeRoute(page: HomeScreen(), routeName: settings.name);
      case eventdetails:
        final eventId = settings.arguments as String;

        return FadeRoute(
          page: BlocProvider(
            create: (context) => EventDetailsCubit(newseventsRepo),
            child: EventDetailsScreen(eventId: eventId),
          ),
          routeName: settings.name,
        );
      case courseDeatailScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final Course course = args['course'] as Course;
        final bool isNew = args['isNew'] as bool;
        return FadeRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CourseRegistrationCubit(coursedetailsRepo),
              ),
              BlocProvider(
                create: (context) => CoursedetailsCubit(coursedetailsRepo),
              ),
              BlocProvider(
                create: (context) => CourseLikeCubit(coursedetailsRepo),
              ),
            ],
            child: CourseDetailsScreen(course: course, isNew: isNew),
          ),
          routeName: settings.name,
        );
      default:
        return null;
    }
  }
}

class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final String? routeName;
  final Duration duration;
  final Curve curve;

  FadeRoute({
    required this.page,
    this.routeName,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  }) : super(
         settings: RouteSettings(name: routeName),
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) => page,
         transitionsBuilder: (
           BuildContext context,
           Animation<double> animation,
           Animation<double> secondaryAnimation,
           Widget child,
         ) {
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: curve,
           );
           return FadeTransition(opacity: curvedAnimation, child: child);
         },
       );

  @override
  Duration get transitionDuration => duration;
}
