import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Tipo } from '../../shared/entidades/tipo';

@Injectable({
  providedIn: 'root'
})
export class TipoService {
  private url: string;

  constructor(private http: HttpClient) {
    this.url = `${environment.urlService}tipos/`;
  }

  public listar(): Observable<Tipo[]> {
    return this.http.get<Tipo[]>(`${this.url}listar`);
  }

  public buscar(dato: String): Observable<Tipo[]> {
    return this.http.get<Tipo[]>(`${this.url}buscar/${dato}`);
  }

  public agregar(seleccion: Tipo): Observable<Tipo> {
    return this.http.post<Tipo>(`${this.url}agregar`, seleccion);
  }

  public modificar(seleccion: Tipo): Observable<Tipo> {
    return this.http.put<Tipo>(`${this.url}modificar`, seleccion);
  }

  public eliminar(idTipo: number): Observable<boolean> {
    return this.http.delete<boolean>(`${this.url}eliminar/${idTipo}`);
  }
}
