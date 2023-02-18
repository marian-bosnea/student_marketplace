abstract class FormSubmissionStatus {}

class InitalFormStatus implements FormSubmissionStatus {
  const InitalFormStatus();
}

class FormSubmitting implements FormSubmissionStatus {}

class SubmissionSuccess implements FormSubmissionStatus {}

class SubmissionFailed implements FormSubmissionStatus {
  final Exception exception;

  SubmissionFailed({required this.exception});
}
