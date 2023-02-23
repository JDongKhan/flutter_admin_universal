class TreeNode {
  String title;
  bool expanded;
  bool checked;
  bool editable;
  dynamic extra;
  List<TreeNode> children;

  TreeNode({
    required this.title,
    required this.expanded,
    required this.checked,
    required this.children,
    this.editable = false,
    this.extra,
  });
}
