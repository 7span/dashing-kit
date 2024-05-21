class ReminderEntity {
  ReminderEntity({
    this.title,
    this.subTitle,
    this.id,
    this.reminderDate,
    this.imageUrl,
    this.blurHashUrl,
  });

  final String? imageUrl;
  final String? blurHashUrl;
  final String? title;
  final String? subTitle;
  final String? reminderDate;
  final int? id;
}
