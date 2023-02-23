import 'package:flutter/material.dart';

import 'chart/pie_chart_sample1.dart';
import 'chart/pie_chart_sample2.dart';
import 'info_card_widget.dart';

class ForthSection extends StatelessWidget {
  const ForthSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Column(
          children: [
            buildTitleWidget(title: '涉及领域', tip: '涉及领域'),
            PieChartSample2(),
            _buildIntroduceWidget(icon: Icons.man, title: 'UI/UX设计'),
            _buildIntroduceWidget(icon: Icons.camera, title: '品牌视觉设计'),
            _buildIntroduceWidget(icon: Icons.man, title: '网页网站设计'),
            _buildIntroduceWidget(icon: Icons.man, title: 'B端管理系统设计'),
            buildTitleWidget(title: '项目开发进度'),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: const [
                  Text('前端项目进度'),
                  SizedBox(
                    width: 10,
                  ),
                  CircularProgressIndicator(
                    value: 0.4,
                    strokeWidth: 2,
                    color: Colors.red,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '40%',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduceWidget(
      {required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }
}
