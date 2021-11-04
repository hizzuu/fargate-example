package infrastructure

import (
	"context"
	"database/sql"
)

type contextKey string

const txCtxKey contextKey = "tx"

type sqlHandler struct {
	db *sql.DB
}

type SqlHandler interface {
	DoInTx(ctx context.Context, f func(ctx context.Context) (interface{}, error)) (interface{}, error)
	PrepareContext(ctx context.Context, query string) (*sql.Stmt, error)
}

func NewSqlHandler(db *sql.DB) SqlHandler {
	return &sqlHandler{
		db: db,
	}
}

func (h *sqlHandler) DoInTx(ctx context.Context, f func(ctx context.Context) (interface{}, error)) (interface{}, error) {
	tx, err := h.db.BeginTx(ctx, &sql.TxOptions{})
	if err != nil {
		return nil, err
	}
	ctx = context.WithValue(ctx, txCtxKey, tx)
	v, err := f(ctx)
	if err != nil {
		tx.Rollback()
		return nil, err
	}
	if err := tx.Commit(); err != nil {
		tx.Rollback()
		return nil, err
	}
	return v, nil
}

func (h *sqlHandler) PrepareContext(ctx context.Context, query string) (*sql.Stmt, error) {
	if tx, ok := ctx.Value(txCtxKey).(*sql.Tx); ok {
		return tx.PrepareContext(ctx, query)
	}
	return h.db.PrepareContext(ctx, query)
}
