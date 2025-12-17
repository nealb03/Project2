import React from 'react'
import './index.css'

function App() {
  return (
    <div className="app">
      <header className="app-header">
        <h1>Project2 Frontend</h1>
        <p>This is a basic React + Vite frontend wired for GitHub Actions deployment.</p>
      </header>

      <main className="app-main">
        <section className="card">
          <h2>Status</h2>
          <p>Frontend build is managed by GitHub Actions and deployed via your backend CI/CD pipeline.</p>
        </section>

        <section className="card">
          <h2>Next Steps</h2>
          <ul>
            <li>Customize this UI to match your application requirements.</li>
            <li>Connect to your backend API.</li>
            <li>Add routing, state management, and components as needed.</li>
          </ul>
        </section>
      </main>
    </div>
  )
}

export default App
