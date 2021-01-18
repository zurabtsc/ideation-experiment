import 'dart:developer';

import 'package:fu_ideation/APIs/firestore.dart';
/*

Future<double> getAverageRating(int projectId, int ideaId) async {
  Map projectDocMap = await firestoreGetDoc('project_' + projectId.toString(), 'idea_' + ideaId.toString());
  List ratings = [];
  for(final e in projectDocMap['ratings']){
    ratings.add(e['rating']);
  }

  if (ratings == null || ratings.isEmpty) return null;
  double _sum = 1.0 * ratings.reduce((a, b) => a + b);
  double _avg = _sum / ratings.length;
  if (_avg > 5.0) return 5.0;
  return _sum / ratings.length;
}
*/


double getAverageRating2(List ratingsMaps) {
  if (ratingsMaps == null || ratingsMaps.isEmpty) return null;
  Map userUniqueRatings = {};
  List ratings = [];
  for(final e in ratingsMaps){
      userUniqueRatings[e['author_invitation_code']] = e;
  }

  userUniqueRatings.forEach((k, v) {
    ratings.add(v['rating']);
  });


  if (ratings == null || ratings.isEmpty) return null;
  log(ratings.toString());
  double _sum = 1.0 * ratings.reduce((a, b) => a + b);
  double _avg = _sum / ratings.length;
  if (_avg > 5.0) return 5.0;
  log((_sum / ratings.length).toString());
  return _sum / ratings.length;
}
