import { Routes } from '@angular/router';
import { InicioComponent } from '../features/componentes/inicio/inicio.component';
import { FestivoComponent } from '../features/componentes/festivo/festivo.component';
import { TipoComponent } from '../features/componentes/tipo/tipo.component';
import { PaisComponent } from '../features/componentes/pais/pais.component';

export const routes: Routes = [
    { path: "", redirectTo: "inicio", pathMatch: "full" },
    { path: "inicio", component: InicioComponent },
    { path: "festivos", component: FestivoComponent },
    { path: "tipos", component: TipoComponent },
    { path: "paises", component: PaisComponent },
];
