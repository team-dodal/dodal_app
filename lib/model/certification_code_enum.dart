enum CertCode {
  fail('인증 실패'),
  pending('인증 대기'),
  success('인증 성공');

  const CertCode(this.name);
  final String name;
}
