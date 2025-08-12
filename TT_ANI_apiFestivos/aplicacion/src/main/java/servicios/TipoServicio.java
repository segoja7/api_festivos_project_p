package festivos.api.aplicacion.servicios;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.data.domain.Sort;

import festivos.api.core.servicios.*;
import festivos.api.dominio.entidades.*;
import festivos.api.infraestructura.repositorios.*;

@Service
public class TipoServicio implements ITipoServicio {

    private ITipoRepositorio repositorio;

    public TipoServicio(ITipoRepositorio repositorio) {
        this.repositorio = repositorio;
    }

    @Override
    public List<Tipo> listar() {
        return repositorio.findAll(Sort.by(Sort.Direction.ASC, "nombre"));
    }

    @Override
    public Tipo obtener(int id) {
        return repositorio.findById(id).isEmpty() ? null : repositorio.findById(id).get();
    }

    @Override
    public List<Tipo> buscar(String nombre) {
        return repositorio.buscar(nombre);
    }

    @Override
    public Tipo agregar(Tipo tipo) {
        tipo.setId(0);
        return repositorio.save(tipo);
    }

    @Override
    public Tipo modificar(Tipo tipo) {
        if (repositorio.findById(tipo.getId()).isEmpty())
            return null;
        return repositorio.save(tipo);
    }

    @Override
    public boolean eliminar(int id) {
        try {
            repositorio.deleteById(id);
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

}
