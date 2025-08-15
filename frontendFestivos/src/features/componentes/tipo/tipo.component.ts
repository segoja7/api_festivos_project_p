import { Component } from '@angular/core';
import { Tipo } from '../../../shared/entidades/tipo';
import { ColumnMode, NgxDatatableModule, SelectionType } from '@swimlane/ngx-datatable';
import { TipoService } from '../../../core/servicios/tipo.service';
import { MatDialog } from '@angular/material/dialog';
import { TipoEditarComponent } from '../tipo-editar/tipo-editar.component';
import { DecidirComponent } from '../../../shared/componentes/decidir/decidir.component';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-tipo',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
    NgxDatatableModule,
  ],
  templateUrl: './tipo.component.html',
  styleUrl: './tipo.component.css'
})
export class TipoComponent {

  public textoBusqueda: string = "";
  public tipos: Tipo[] = [];
  public columnas = [
    { name: "Nombre", prop: "nombre" },
  ];
  public modoColumna = ColumnMode;
  public tipoSeleccion = SelectionType;

  public tipoEscogido: Tipo | undefined;
  public indiceTipoEscogido: number = -1;

  constructor(private tipoServicio: TipoService,
    public dialogServicio: MatDialog,
  ) {
  }

  ngOnInit(): void {
    this.listar();
  }

  escoger(event: any) {
    if (event.type == "click") {
      this.tipoEscogido = event.row;
      this.indiceTipoEscogido = this.tipos.findIndex(tipo => tipo == this.tipoEscogido);
    }
  }

  public listar() {
    this.tipoServicio.listar().subscribe(
      {
        next: response => {
          this.tipos = response;
        },
        error: error => {
          window.alert(error);
        }
      }
    );
  }

  public buscar() {
    if (this.textoBusqueda.length == 0) {
      this.listar();
    }
    else {
      this.tipoServicio.buscar(this.textoBusqueda).subscribe({
        next: response => {
          this.tipos = response;
        },
        error: error => {
          window.alert(error);
        }
      });
    }
  }
  agregar() {
    const dialogRef = this.dialogServicio.open(TipoEditarComponent, {
      width: '500px',
      height: '300px',
      data: {
        encabezado: "Agregando un nuevo Tipo",
        tipo: {
          id: 0,
          nombre: "",
        },
      },
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe({
      next: datos => {
        if (datos) {
          this.tipoServicio.agregar(datos.tipo).subscribe({
            next: response => {
              this.tipoServicio.buscar(response.nombre).subscribe({
                next: response => {
                  this.tipos = response;
                },
                error: error => {
                  window.alert(error);
                }
              });
            },
            error: error => {
              window.alert(error);
            }
          });
        }
      },
      error: error => {
        window.alert(error);
      }
    }
    );
  }
  modificar() {
    if (this.tipoEscogido) {
      const dialogRef = this.dialogServicio.open(TipoEditarComponent, {
        width: '500px',
        height: '300px',
        data: {
          encabezado: `Editando el Tipo [${this.tipoEscogido.nombre}]`,
          tipo: this.tipoEscogido,
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.tipoServicio.modificar(datos.tipo).subscribe({
              next: response => {
                this.tipos[this.indiceTipoEscogido] = response;
              },
              error: error => {
                window.alert(error.message);
              }
            });
          }
        }
      });
    }
    else {
      window.alert("Se debe elegir un Tipo de la lista");
    }
  }
  verificarEliminar() {
    if (this.tipoEscogido) {
      const dialogRef = this.dialogServicio.open(DecidirComponent, {
        width: "300px",
        height: "200px",
        data: {
          encabezado: `Está seguro de eliminar el Tipo [${this.tipoEscogido.nombre}]`,
          id: this.tipoEscogido.id
        },
        disableClose: true,
      });

      dialogRef.afterClosed().subscribe({
        next: datos => {
          if (datos) {
            this.tipoServicio.eliminar(datos.id).subscribe({
              next: response => {
                if (response) {
                  this.listar();
                  window.alert("El Tipo fue eliminada");
                }
                else {
                  window.alert("No se pudo eliminar el Tipo");
                }
              },
              error: error => {
                window.alert(error.message);
              }
            });
          }
        }
      });
    }
    else {
      window.alert("Se debe elegir un Tipo de la lista");
    }
  }

}
