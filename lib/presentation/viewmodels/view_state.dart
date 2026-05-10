enum ViewStatus { inicial, carregando, sucesso, erro }

class ViewState {
  final ViewStatus status;
  final String? mensagemErro;

  const ViewState._({
    required this.status,
    this.mensagemErro,
  });

  const ViewState.inicial() : this._(status: ViewStatus.inicial);
  const ViewState.carregando() : this._(status: ViewStatus.carregando);
  const ViewState.sucesso() : this._(status: ViewStatus.sucesso);
  const ViewState.erro(String mensagem)
      : this._(status: ViewStatus.erro, mensagemErro: mensagem);

  bool get estaCarregando => status == ViewStatus.carregando;
  bool get temErro => status == ViewStatus.erro;
  bool get temSucesso => status == ViewStatus.sucesso;
}