✅ Solution – Copilot with Custom Conversation Flow

Below is the full summary and repository structure you can publish on GitHub.

1. Summary of What I Learned

During the practical demonstration, I learned how to build a Copilot with a custom conversation flow inside Microsoft Copilot Studio.
The main ideas were:

• Understanding Custom Conversation Flow

A custom flow allows the Copilot to follow a controlled path.
It is useful when the assistant needs to ask questions step-by-step, validate answers, or guide the user through a small process.

I learned that a flow can:

Start with a trigger

Ask questions

Store user responses

Make conditions

Call actions

Use AI to create flexible answers

• Creating the Copilot

Steps practiced in the demonstration:

Create a new Copilot

Open the “Topics” area

Create a topic with a custom flow

Add trigger phrases

Build the conversation steps

The platform uses a visual editor, where each step of the flow is created as a node.

• Designing the Flow

I learned to use:

Questions: to collect information from the user

Variables: to store answers

Conditions: to change the path based on user input

Messages: to guide the conversation

Actions: to call external services or automations

This allows the Copilot to talk in a more structured and intelligent way.

• Testing the Flow

The integrated tester lets me:

Simulate the conversation

Check if the logic works

Fix errors in conditions or variables

Improve the interaction

Testing is fast and happens inside the platform.

• Publishing the Copilot

After building and testing, I can publish the Copilot to:

Microsoft 365

Website embed

Channels inside the organization

The Copilot becomes available for users with the defined flow.

2. What I Built for This Challenge

For the challenge, I created a simple Copilot with a custom conversation flow designed to:

Welcome the user

Ask one or two questions

Decide the next step based on the answer

Show a final response

This demonstrates the use of triggers, questions, conditions, variables and structured flow.

3. Repository Structure to Upload on GitHub

Use this structure:

/custom-conversation-copilot/
│── README.md
│── summary.md
│── flow-diagram.png   (optional)
│── screenshots/
│       ├── topic.png
│       ├── flow.png
│       └── tester.png

4. README.md Template (copy into your repo)
# Custom Conversation Flow – Microsoft Copilot Studio

This project is my solution for the DIO challenge:
**“Criando um Copiloto com Fluxo de Conversa Personalizado”.**

## 📘 Summary
I explored the demonstration and learned:
- How to create a Copilot
- How to build a custom conversation flow
- How to add questions, variables and conditions
- How to test and publish the Copilot

See full details in `summary.md`.

## 📂 Project Files
- `summary.md` → Detailed learning summary
- `screenshots/` → Images from Copilot Studio
- `flow-diagram.png` → Optional flow illustration

## 🚀 Documentation
Microsoft Copilot Studio docs:
https://learn.microsoft.com/pt-br/microsoft-copilot-studio/

## ✔ Challenge Delivery
The link to this repository should be submitted in the challenge platform.
