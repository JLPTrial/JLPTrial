import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [message, setMessage] = useState('Carregando mensagem do backend...')
  const [error, setError] = useState('')

  useEffect(() => {
    const endpoint = import.meta.env.VITE_API_URL

    fetch(endpoint)
      .then(async (response) => {
        if (!response.ok) {
          throw new Error(`Falha na resposta do backend (${response.status})`)
        }

        const data = (await response.json()) as { message: string }
        setMessage(data.message)
      })
      .catch((err: unknown) => {
        const reason = err instanceof Error ? err.message : 'Erro desconhecido'
        setError(reason)
        setMessage('Não foi possível buscar a mensagem do backend.')
      })
  }, [])

  const isOnline = !error

  // Sim, pedi para o gepetto me gerar esse template, mim não saber fazer design : D
  return (
    <div className="app-shell">
      <header className="top-nav">
        <strong className="brand">JLPTrial</strong>
        <nav className="top-links" aria-label="Navegacao principal">
          <a href="#">Questões</a>
          <a href="#">Meu Progresso</a>
          <a href="#">Minha Conta</a>
        </nav>
      </header>

      <main className="web-home">
        <section className="jlpt-card" aria-live="polite">
          <h1>JLPTrial Web</h1>
          <p className="jlpt-subtitle">
            VOCÊ CONSEGUIU! Tá tudo certo agora!
          </p>

          <div className={`status-pill ${isOnline ? 'ok' : 'error'}`}>
            <span className="dot" aria-hidden="true" />
            <span>{isOnline ? 'Backend conectado' : 'Falha de conexao'}</span>
          </div>

          <p className="response-label">Resposta do backend</p>
          <pre>{message}</pre>
        </section>
      </main>
    </div>
  )
}

export default App
