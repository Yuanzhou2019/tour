/// Purpose of visiting China. Used by Prepare Home to filter the policy cards
/// and checklist shown to the user — e.g. an `education` visitor needs X1
/// visa + residence permit callouts, while a `tourism` visitor only needs
/// the 30-day visa-free / customs / embassy cards.
enum EntryReason {
  tourism('tourism', 'Tourism', '旅游', 'Sightseeing, family trip, short visit'),
  business('business', 'Business', '商务', 'Meetings, trade fair, client visit'),
  familyVisit(
    'family_visit',
    'Family visit',
    '探亲',
    'Visiting relatives or friends',
  ),
  education('education', 'Education', '留学', 'Studying, exchange, research'),
  work('work', 'Work', '工作', 'Employment, assignment, posting');

  const EntryReason(this.id, this.labelEn, this.labelZh, this.description);
  final String id;
  final String labelEn;
  final String labelZh;
  final String description;
}
