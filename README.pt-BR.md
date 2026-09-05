# Aurora DS

**Um design system, duas linguagens visuais.** Um app Flutter com forma de produção que renderiza cada tela nativamente em **Material 3** *e* **Cupertino**, totalmente localizado em **inglês, português e alemão** — feito para ser lido como referência de arquitetura, de design system e de internacionalização.

[![Flutter](https://img.shields.io/badge/Flutter-3.44-blue?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> 🇬🇧 [Read in English](README.md)

---

## O que este repositório realmente demonstra

A maioria dos exemplos de "design system" é uma galeria de widgets. Este tenta responder à pergunta mais difícil: **o que precisa ser verdade na sua arquitetura para um design system sobreviver ao contato com um app real?**

| | |
|---|---|
| **Um pipeline de tokens, não um arquivo de tema** | Uma cor de marca → papéis semânticos de cor, escala tipográfica, raios, elevação e movimento → `ThemeData` *e* `CupertinoThemeData`. Os dois frameworks são *saídas* da mesma fonte da verdade e, por isso, não conseguem divergir. |
| **Adaptativo por escolha, não por plataforma** | A pessoa escolhe Material ou Cupertino em tempo de execução, em qualquer dispositivo. A troca remonta o app inteiro — `MaterialApp` ⇄ `CupertinoApp` — e todas as telas acompanham sem uma única edição. |
| **Uma fronteira rígida de import** | Exatamente um arquivo fora de `lib/design_system/` importa `material.dart` ou `cupertino.dart` — o `lib/app/app.dart`, que monta um dos dois app widgets. O código de feature fisicamente *não consegue* passar por cima do sistema, e um teste garante isso. |
| **Localização como cidadã de primeira classe** | 161 chaves × 3 idiomas, com plurais, datas e moeda sensíveis ao locale. Tradução faltando quebra o build, não a experiência. |
| **Features em camadas** | `domain` (Dart puro) → `data` (I/O) → `application` (estado) → `presentation` (widgets), com inversão de dependência na costura do repositório. |
| **Testes que pegariam uma regressão** | 65 testes cobrindo resolução de tokens, as duas renderizações de cada componente interativo, persistência, regras de negócio puras, qualidade de tradução, o fluxo de onboarding, navegação do app completo — e a própria fronteira de imports. |

---

## Começando

```bash
flutter --version        # 3.44.2 ou mais novo
flutter pub get
flutter gen-l10n         # gera lib/l10n/generated (o `flutter run` também roda)
flutter run
```

Comandos úteis:

```bash
flutter test                       # 65 testes
flutter analyze --fatal-infos      # o analisador faz parte do contrato
dart format lib test
flutter run -d chrome              # deep links funcionam: /components/segmented-control
```

---

## A ideia em um diagrama

```
                    ┌──────────────────────────────┐
    ajustes    ────►│  AppSettings (Dart puro)     │
                    │  designLanguage · themeMode  │
                    │  brand · language            │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  DSThemeData.resolve(...)    │   ← a única fonte da verdade
                    │  colors · typography         │
                    │  radii · elevation · motion  │
                    └───────┬──────────────┬───────┘
                            │              │
              ┌─────────────▼──┐        ┌──▼──────────────┐
              │ ThemeData      │        │ CupertinoTheme  │
              │ (Material 3)   │        │ Data            │
              └─────────┬──────┘        └──────┬──────────┘
                        │                      │
              ┌─────────▼──────┐        ┌──────▼──────────┐
              │  MaterialApp   │        │  CupertinoApp   │
              └─────────┬──────┘        └──────┬──────────┘
                        └───────┬──────────────┘
                                │
                    ┌───────────▼──────────────┐
                    │  DSButton · DSTextField  │  ← uma API, duas renderizações
                    │  DSListSection · …       │
                    └───────────┬──────────────┘
                                │
                    ┌───────────▼──────────────┐
                    │  Telas de feature        │  ← nunca importam material/cupertino
                    └──────────────────────────┘
```

Os dois temas do framework são **derivados**, nunca escritos à mão. Troque a semente de `DSBrand.aurora` e o diálogo Material, o picker Cupertino, a navigation rail e o toast se movem juntos.

---

## Arquitetura

```
lib/
├── main.dart                     raiz de composição: monta dependências e chama runApp
├── app/
│   ├── app.dart                  ajustes → DSThemeData → MaterialApp | CupertinoApp
│   ├── application/              providers derivados (linguagem visual, locale, tema)
│   ├── router/                   configuração do go_router + enum de todas as rotas
│   └── widgets/                  shell de navegação adaptativa (tab bar ⇄ rail)
├── core/                         utilitários transversais (extensões de contexto, metadados)
├── design_system/                ← único lugar autorizado a importar material/cupertino
│   ├── foundations/              tokens: cor, tipografia, espaçamento, raio, elevação, movimento
│   ├── theme/                    DSThemeData + os dois construtores de tema
│   ├── components/               16 componentes DS*
│   └── design_system.dart        a superfície pública; features importam isso e nada mais
├── features/
│   ├── onboarding/               introdução interativa em cinco passos
│   ├── foundations/              tela viva de referência dos tokens
│   ├── catalog/                  galeria de componentes + páginas de detalhe com deep link
│   ├── playground/               tela realista de reserva feita só com componentes do DS
│   └── settings/                 os quatro controles que dirigem a demonstração
└── l10n/
    ├── arb/                      app_en.arb · app_pt.arb · app_de.arb
    └── generated/                produzido por `flutter gen-l10n` (versionado)
```

### Regras de camada

Cada feature é dividida da mesma forma, e as dependências só apontam para baixo:

```
presentation ──► application ──► domain ◄── data
   widgets        controllers     entidades   repositórios,
   (consumers      (Notifier,     + interfaces  data sources
    Riverpod)    estado puro)   de repositório
```

* **`domain/`** é Dart puro — sem `BuildContext`, sem Flutter, sem I/O. `BookingDraft` conhece as regras de preço; `AppSettings` conhece o que é uma configuração válida. É por isso que os testes de regra de negócio rodam em milissegundos.
* **`data/`** implementa as interfaces declaradas no domínio. `SettingsRepositoryImpl` escreve através da costura estreita `KeyValueStore`, então os testes trocam `SharedPreferences` por `InMemoryKeyValueStore` sem nenhum platform channel.
* **`application/`** guarda os `Notifier` do Riverpod. As transições de estado são funções totais; nada aqui toca em widgets.
* **`presentation/`** é só widget, e só pode falar design system.

### Injeção de dependência

Tudo o que o app precisa do mundo externo é criado em `main()` e injetado para baixo:

```dart
runApp(
  ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(repository),
      initialSettingsProvider.overrideWithValue(settings),
    ],
    child: const AuroraApp(),
  ),
);
```

Os dois providers lançam erro se não forem sobrescritos, então uma dependência faltando é uma falha barulhenta na inicialização, não um default silencioso. O app inteiro monta em um teste de widget com esses mesmos dois overrides mais um para a plataforma — veja `test/helpers/pump_app.dart`.

Os ajustes são lidos do disco **antes do primeiro frame**. Um app de design system que pisca o tema errado por 200ms desmente o próprio propósito.

---

## O design system

### Tokens

| Token | Tipo | Depende de plataforma? | Observações |
|---|---|---|---|
| `DSColors` | papéis semânticos | em parte | Gerado de uma semente pelo algoritmo tonal do Material 3; o Cupertino sobrescreve fundos agrupados e separadores de um pixel |
| `DSTypography` | 8 papéis | sim | O corpo do Material começa em 14pt, o do Cupertino em 17pt — mesmos nomes, métricas diferentes |
| `DSSpacing` | grade de 4pt | não | `xxs` 2 → `xxxl` 48; o ritmo é compartilhado de propósito |
| `DSRadii` | 4 papéis + pill | sim | Os cantos do Material são visivelmente mais suaves que os do Cupertino |
| `DSElevation` | 4 níveis | sim | Material tinge e projeta sombra; Cupertino devolve lista vazia e usa bordas |
| `DSMotion` | 4 durações, 4 curvas | não | Um sistema de movimento calmo lê melhor que dois competindo |
| `DSBreakpoints` | 3 classes de janela | não | Alinhado às window size classes do Material 3 |

Os tokens são publicados por um `InheritedWidget` simples (`DSTheme`) que fica **acima** de `MaterialApp`/`CupertinoApp`, então sobrevivem à troca entre os dois e ficam trivialmente disponíveis em testes:

```dart
final ds = context.ds;           // DSThemeData
ds.colors.brand                  // papel semântico, nunca um literal hexadecimal
ds.radii.control                 // resolvido para a linguagem visual ativa
ds.select(material: 16, cupertino: 12);
```

### Componentes

16 componentes, cada um com uma API e duas renderizações:

| Grupo | Componentes |
|---|---|
| Ações | `DSButton` (4 intenções, loading, ícone, expand), `DSIconButton` |
| Entradas | `DSTextField` (rótulo, apoio, erro, desabilitado) |
| Seleção | `DSSwitch`, `DSSlider`, `DSSegmentedControl<T>` |
| Contêineres | `DSCard`, `DSListSection` / `DSListRow`, `DSAvatar`, `DSBadge` |
| Feedback | `DSFeedback.confirm`, `DSFeedback.actionSheet`, `DSFeedback.toast`, `DSProgressIndicator` |
| Layout | `DSScaffold`, `DSPageBody`, `DSNavigationScaffold`, `DSSectionHeader`, `DSGap`, `DSText` |

Aparecem três tipos de componente, e a distinção importa:

1. **Invólucros** — `DSSwitch` escolhe `Switch` ou `CupertinoSwitch`. Trivial, e ainda assim vale a pena ser dono: `Switch.adaptive` se adapta ao *dispositivo*, este se adapta à *escolha da pessoa*.
2. **Reconciliadores** — `DSSegmentedControl` faz a ponte entre `SegmentedButton` (recebe um `Set`) e `CupertinoSlidingSegmentedControl` (recebe um `Map`). `DSTextField` reconcilia o rótulo flutuante com a legenda empilhada. A incompatibilidade para no componente.
3. **Do próprio sistema** — `DSBadge`, `DSAvatar` e `DSFeedback.toast` não têm equivalente no Cupertino, então o design system os define por conta própria. O toast é desenhado no `Overlay` raiz, e é por isso que se comporta igual sob os dois app widgets.

### A regra de import

`lib/design_system/design_system.dart` é toda a superfície pública. Arquivos de feature importam esse barrel e, no máximo, um conjunto de ícones com um `show Icons` / `show CupertinoIcons` explícito. O único arquivo fora do design system que importa um framework inteiro é o `lib/app/app.dart`, que existe justamente para montar `MaterialApp` ou `CupertinoApp`.

Isso não é uma convenção que alguém precisa lembrar — o `test/architecture/import_boundary_test.dart` percorre `lib/` e quebra o build se uma feature passar por cima do sistema, se um import de ícones trouxer mais do que ícones, ou se um componente for definido e nunca exportado no barrel.

---

## Localização

Três idiomas, sem fallback disfarçado:

| | English | Português | Deutsch |
|---|---|---|---|
| Chaves | 161 | 161 | 161 |
| Plurais | ✅ | ✅ | ✅ |
| Datas | `Sunday, March 22, 2026` | `domingo, 22 de março de 2026` | `Sonntag, 22. März 2026` |
| Moeda | `$1,234.50` | `R$ 1.234,50` | `1.234,50 €` |

O `l10n.yaml` define `required-resource-attributes: true` e grava qualquer mensagem faltante em `l10n_missing.json`, então uma chave sem tradução vira problema de build. O `test/l10n/localizations_test.dart` vai além e verifica que as traduções são de fato *diferentes* do inglês — pegando o bug mais sutil da chave copiada e nunca traduzida.

**Adicionar um idioma** são três passos:

1. Copie `lib/l10n/arb/app_en.arb` para `app_<código>.arb`, traduza os valores e mantenha as chaves.
2. Adicione o caso em `AppLanguage` (`lib/features/settings/domain/app_settings.dart`) e uma chave de rótulo para ele.
3. Rode `flutter gen-l10n`. A tela de ajustes reconhece sozinha.

Nada mais muda — a lista de idiomas na interface é gerada a partir do enum.

---

## Onboarding

O primeiro acesso redireciona para `/onboarding`, uma introdução de cinco passos que ensina o app **deixando você dirigir**. Os passos 2 a 4 não são ilustrações — eles alteram os ajustes de verdade, então o app inteiro troca de skin, de tema e de idioma por baixo da introdução enquanto ela ainda está na tela.

| Passo | O que diz | O que dá para fazer |
|---|---|---|
| **Boas-vindas** | um design system, um conjunto de tokens | — |
| **Linguagem visual** | Material vs. Cupertino vs. Automático | troque, e a prévia ao vivo abaixo (campo de texto, interruptor e botão) renderiza no outro framework |
| **Aparência** | claro/escuro e uma cor de marca | troque qualquer um, e a grade de amostras é redesenhada com a paleta regerada |
| **Idioma** | English · Português · Deutsch | troque, e o texto da introdução, a data, o plural e a moeda da prévia mudam juntos |
| **Tour** | para que serve cada uma das quatro abas | finalize, ou pule a qualquer momento |

Dois detalhes que valem nota:

* **O passo vive no estado do app, não no widget.** O `onboardingStepProvider` sobrevive à remontagem `MaterialApp` ⇄ `CupertinoApp`, então trocar a linguagem visual no passo 2 mantém você no passo 2 em vez de voltar ao início. Um `PageView` não consegue isso — a posição de scroll é reconstruída a partir de `initialPage` quando o scrollable é reanexado — então o conteúdo do passo é dirigido por um `AnimatedSwitcher` com um gesto de swipe horizontal por cima.
* **A conclusão é persistida como qualquer outro ajuste.** `AppSettings.hasCompletedOnboarding` passa pelo mesmo repositório, e o `Restaurar ajustes` preserva esse valor de propósito — resetar o tema não deveria repetir o tutorial. Os ajustes têm uma linha **Rever a introdução** para quando você realmente quiser.

---

## Navegação

`go_router` com `StatefulShellRoute.indexedStack`: quatro ramos, cada um com seu próprio histórico. As transições de página são escolhidas a cada navegação a partir da linguagem visual ativa, então uma sessão Cupertino ganha o push horizontal com swipe de voltar e uma sessão Material ganha o fade-forwards.

Toda rota é declarada uma vez em `AppRoute`, e as páginas de detalhe têm deep link:

```
/onboarding                       ← o primeiro acesso é redirecionado para cá
/foundations
/components
/components/segmented-control     ← teste no build web
/playground
/settings
```

Os slugs são escritos explicitamente em vez de derivados dos identificadores Dart — renomear uma constante não pode quebrar o favorito de alguém. Um slug desconhecido volta para a galeria em vez de quebrar, porque deep link é entrada de usuário.

### Layout responsivo

| Janela | Navegação | Conteúdo |
|---|---|---|
| `< 600dp` | barra inferior (`NavigationBar` / `CupertinoTabBar`) | coluna única |
| `600–960dp` | rail de ícones | coluna única, limitada a 720dp |
| `> 960dp` | rail estendida com rótulos | coluna centralizada, limitada a 720dp |

---

## Testes

```
test/
├── architecture/import_boundary_test.dart   as regras de camada, garantidas pela suíte
├── helpers/pump_app.dart              monta um componente, ou o app inteiro, com temas e l10n reais
├── design_system/
│   ├── ds_theme_test.dart             resolução de tokens, derivação de paleta, igualdade
│   ├── ds_button_test.dart            as duas renderizações, desabilitado, carregando
│   └── ds_components_test.dart        switch, campo de texto, segmented, avatar, ciclo do toast
├── features/
│   ├── settings/                      ida e volta do repositório, recuperação de valor corrompido, controller
│   ├── onboarding/                    primeiro acesso, troca de skin no meio do fluxo, rever pelos ajustes
│   └── playground/                    regras de preço, validação, clamp, relógio injetado
├── l10n/localizations_test.dart       cobertura, plurais, formatação de data e moeda por locale
└── app/app_smoke_test.dart            boot, navegação, deep link, troca de idioma e de linguagem visual
```

Dois hábitos que valem copiar:

* **Iterar sobre a linguagem visual.** Componentes interativos são verificados nas *duas* renderizações dentro de um único teste, então uma regressão só do Cupertino não tem onde se esconder.
* **Injetar o relógio.** `clockProvider` torna a data de partida formatada verificável em vez de instável à meia-noite.

```dart
for (final language in DesignLanguage.values) {
  await pumpComponent(tester, DSSwitch(...), designLanguage: language);
  await tester.tap(find.byType(DSSwitch));
  expect(received, isTrue, reason: 'no change reported in $language');
}
```

---

## Portões de qualidade

Rode isto antes de commitar:

```bash
flutter gen-l10n                                  # regera lib/l10n/generated
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
flutter build web --release
```

O analisador é o `flutter_lints` mais alguns extras: `always_use_package_imports`,
`directives_ordering`, `prefer_single_quotes`, `sort_constructors_first` e
`unawaited_futures`.

---

## Receitas

<details>
<summary><b>Adicionar um componente</b></summary>

1. Crie `lib/design_system/components/ds_coisa.dart`. Ramifique em `context.ds.isCupertino` **uma vez**, no topo do `build`.
2. Exporte no `lib/design_system/design_system.dart`.
3. Adicione uma constante em `ComponentId` com o slug de URL e o grupo.
4. Adicione chaves de título/descrição nos três ARB e ligue em `component_copy.dart`.
5. Adicione o exemplar vivo em `component_demo.dart` e um trecho em `component_code.dart`.

O enum torna os passos 4 e 5 obrigatórios: os `switch` não compilam enquanto todos os casos não forem tratados.
</details>

<details>
<summary><b>Adicionar um papel de cor</b></summary>

Adicione o campo em `DSColors`, resolva em `fromSeed` (com override Cupertino se as plataformas realmente discordarem) e inclua em `catalogue`. A tela de Fundamentos renderiza esse mapa, então o papel se documenta sozinho.
</details>

<details>
<summary><b>Adicionar uma tela</b></summary>

Crie `lib/features/<nome>/presentation/<nome>_page.dart` devolvendo `DSScaffold` + `DSPageBody`, adicione um valor em `AppRoute` e registre em `app_router.dart`. Se precisar de estado, escreva antes a entidade em `domain/` e o notifier em `application/` — o widget deve ser a última coisa.
</details>

<details>
<summary><b>Adicionar uma marca</b></summary>

Adicione uma constante em `DSBrand` com a cor semente e uma chave de rótulo nos ARB. O seletor de ajustes itera `DSBrand.values`, então ela aparece sozinha.
</details>

---

## Escolhas deliberadas

Vale dizer com clareza, já que um repositório de referência deve ser honesto sobre suas bordas:

* **O `CupertinoApp` entra por inteiro.** Mais fiel do que tingir um `MaterialApp`, mas significa que widgets exclusivos do Material (`ListTile`, `InkWell`, `Card`) ficam indisponíveis no modo Cupertino. Essa restrição é garantida pela regra de import, não por combinado.
* **Um tema resolvido em vez de `theme`/`darkTheme`.** O brilho é resolvido no `AuroraApp` para que `DSTheme` e `ThemeData` nunca discordem — e porque `CupertinoApp` sequer tem `darkTheme`.
* **Sem geração de código.** Riverpod sem `riverpod_generator`, `copyWith`/`==` escritos à mão em vez de `freezed`. Mais digitação, mas o código que você lê é o código que roda — o que importa mais numa referência do que num produto.
* **Sem arquivos de fonte.** A tipografia é especificada por tamanho, peso e altura de linha; a família continua sendo a padrão da plataforma (San Francisco na Apple, Roboto no resto), que é o que "adaptativo" deveria significar.
* **`shared_preferences` para persistência.** Atrás da interface `KeyValueStore`, então é uma troca de um arquivo só.

---

## Leitura adicional

* [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — camadas, regras de dependência e o raciocínio por trás delas
* [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md) — referência de tokens e contratos dos componentes

## Licença

MIT — veja [LICENSE](LICENSE).
