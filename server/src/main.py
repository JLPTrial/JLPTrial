import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="JLPTrial API")

flavor = os.getenv("APP_FLAVOR", "dev").strip().lower()
origins_key = "PROD_BACKEND_CORS_ORIGINS" if flavor == "prod" else "DEV_BACKEND_CORS_ORIGINS"
origins_raw = os.getenv(origins_key, "*")
origins = [origin.strip() for origin in origins_raw.split(",") if origin.strip()]

if not origins:
    raise ValueError(
        f"Variável de ambiente '{origins_key}' está vazia ou inválida. "
        f"Valor recebido: '{origins_raw}'."
    )

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root() -> dict[str, str]:
    return {"message": "Backend JLPTrial ativo com sucesso."}


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
