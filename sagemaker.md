# Projeto: Previsão de Ações com o Amazon SageMaker Canvas

## 1. Objetivo do Projeto
Criar um modelo de aprendizado de máquina para **prever a demanda de estoque de produtos** usando o **Amazon SageMaker Canvas**, **sem necessidade de programação**.  
O projeto ajuda a decidir **quanto estoque manter** e a **evitar falta ou excesso**.

---

## 2. Seleção do Conjunto de Dados

### Conjunto de dados escolhido
**Conjunto de dados de Vendas e Estoque (CSV)**  
Representa o histórico de vendas e o comportamento do estoque.

### Colunas de exemplo
- `date` → data de vendas  
- `product_id` → código do produto  
- `category` → categoria do produto  
- `units_sold` → quantidade vendida (**meta**)  
- `current_stock` → estoque disponível  
- `price` → preço do produto  
- `promotion` → sim / não  

### Por que este conjunto de dados?
- Realista para previsão de ações  
- Dados baseados no tempo  
- Fácil de entender no Canvas  

### Ação
- Fazer upload do arquivo CSV no **SageMaker Canvas**  
- O conjunto de dados fica armazenado no ambiente do Canvas  

---

## 3. Construir e Treinar o Modelo

### Importar conjunto de dados
- Abrir o **SageMaker Canvas**
- Clicar em **Importar dados**
- Fazer upload do conjunto de dados

### Configurar modelo
- **Tipo de previsão:** Previsão numérica  
- **Coluna alvo:** `units_sold`  
- **Colunas de entrada:**
  - `date`
  - `product_id`
  - `category`
  - `current_stock`
  - `price`
  - `promotion`

### Treinamento
- Clicar em **Criar modelo**
- O Canvas executa automaticamente:
  - Limpeza de dados
  - Seleção do algoritmo
  - Treinamento do modelo

⏳ O tempo de treinamento depende do tamanho do conjunto de dados.

---

## 4. Análise do Modelo

### Métricas de desempenho
O Canvas apresenta:
- RMSE  
- MAE  
- Pontuação R²  

Essas métricas indicam a **precisão da previsão**.

### Importância das variáveis
A interface mostra quais variáveis têm maior impacto, por exemplo:
- `current_stock`
- `price`
- `promotion`

### Melhorias
- Remover variáveis fracas  
- Adicionar mais dados históricos  
- Retreinar o modelo  

---

## 5. Fazer Previsões

### Processo de previsão
- Carregar novos dados (datas futuras)
- Usar a opção **Prever** no Canvas

### Saída
- `units_sold` previsto
- Base para planejamento de estoque

### Exportação dos resultados
- Exportar previsões em **CSV**
- Utilizar para:
  - Planejamento de estoque
  - Relatórios
  - Decisões de negócios

---

## 6. Considerações e Conclusões

### Principais conclusões
- Promoções aumentam significativamente a demanda  
- Variações de preço impactam o estoque  
- Alguns produtos exigem planejamento sazonal  

### Valor para o negócio
- Redução de escassez de estoque  
- Redução de excesso de estoque  
- Melhores decisões de compra  

---

## 7. Ferramentas e Recursos Utilizados

### Serviços da AWS
- Amazon SageMaker Canvas  
- Amazon S3 (armazenamento interno)

### Recursos de aprendizagem
- Documentação oficial do SageMaker Canvas  
- Guia de Introdução ao SageMaker  
- Tutoriais e exemplos do SageMaker  
- Repositório de exemplos do SageMaker no GitHub  
- Materiais de aprendizagem DIO AWS  

### Curso recomendado
**Criação de Modelos de Linguagem na AWS**
- Treinamento de modelos  
- Modelos JumpStart  
- Conceitos de IA generativa  

---

## 8. Resultado Final
✅ Projeto de aprendizado de máquina completo  
✅ Sem necessidade de programação  
✅ Caso de uso real de previsão de ações  
✅ Totalmente alinhado com a proposta do SageMaker Canvas
