// import 'package:DevQuiz/core/core.dart';
import 'package:flutter/material.dart';

import 'package:gpmobile/src/core/app_images.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/progress_indicator_widget.dart';

class QuizCardWidget extends StatelessWidget {
  final String title;
  final String completed;
  final double percent;

  const QuizCardWidget({
    Key key,
    @required this.title,
    @required this.completed,
    @required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.border,
            ),
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                child: Image.asset(AppImages.blocks),
              ),
            ],
          ),
          Text(
            title,
            style: AppTextStyles.heading15,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  completed,
                  style: AppTextStyles.body11,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: ProgressIndicatorWidget(
                    value: percent,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
